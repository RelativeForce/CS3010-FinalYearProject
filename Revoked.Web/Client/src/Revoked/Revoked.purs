module Revoked where

import Prelude

import Levels (allRawLevels, emergeTable)
import Class.Object (draw, position)
import Collision (isCollideObjects, isOutOfWorld)
import Constants (speed)
import Data.Array (any, filter, partition)
import Data.Bullet (Bullet, updateBullet)
import Data.Enemy (Enemy(..), addEnemyBullet, updateEnemy)
import Data.EnemyBullet (EnemyBullet, updateEnemyBullet)
import Data.Foldable (traverse_)
import Data.Particle (Particle, initParticle, updateParticle)
import Data.Player (Player, addBullet, initialPlayer, updatePlayer)
import Effect (Effect)
import Emo8 (emo8)
import Emo8.Action.Draw (cls, emo, emor, drawScaledImage)
import Assets.Images as I
import Emo8.Class.Game (class Game)
import Emo8.Data.Color (Color(..))
import Emo8.Types (MapId)
import Emo8.Data.Emoji as E
import Emo8.Input (isCatchAny)
import Emo8.Utils (defaultMonitorSize, mkAsset)
import Helper (beInMonitor, drawScrollMap, isCollideMapWalls, isCollideMapHazards, checkPlayerCollision)

data State
    = TitleState
    | OverState
    | ClearState
    | PlayState { 
        distance :: Int, 
        player :: Player, 
        bullets :: Array Bullet, 
        enemies :: Array Enemy, 
        particles :: Array Particle, 
        enemyBullets :: Array EnemyBullet,
        mapId :: MapId
    }

instance gameState :: Game State where
    update input TitleState =
        pure $ if isCatchAny input then initialPlayState else TitleState
    update input OverState =
        pure $ if isCatchAny input then initialState else OverState
    update input ClearState =
        pure $ if isCatchAny input then initialState else ClearState
    update input (PlayState s) = do
        -- update pos
        let newPlayer = updatePlayer input s.player

        np <- checkPlayerCollision s.player newPlayer s.distance (isCollideMapWalls s.mapId s.distance)

        let 
            nbullets = map updateBullet s.bullets
            nenemies = map (updateEnemy s.player) s.enemies
            nparticles = map updateParticle s.particles
            nenemyBullets = map updateEnemyBullet s.enemyBullets

        -- player collision
        isHazardColl <- isCollideMapHazards s.mapId s.distance np
        isMapColl <- isCollideMapWalls s.mapId s.distance np

        let isEnemyColl = any (isCollideObjects np) nenemies
            isEnemyBulletColl = any (isCollideObjects np) nenemyBullets

        -- separate objects
        let { yes: collidedEnemies, no: notCollidedEnemies } = partition (\e -> any (isCollideObjects e) nbullets) nenemies
            { yes: collidedBullets, no: notCollidedBullets } = partition (\b -> any (isCollideObjects b) nenemies) nbullets

        -- add new objects
        let newBullets = addBullet input s.player
            newParticles = map (\e -> initParticle (position e)) collidedEnemies
            newEnemies = emergeTable s.mapId s.distance
            newEnemyBullets = notCollidedEnemies >>= addEnemyBullet s.player

        -- fix player position
        let nnp = beInMonitor s.player np

        -- delete objects (out of monitor)
        let nnbullets = filter (not <<< isOutOfWorld) notCollidedBullets
            nnenemies = filter (not <<< isOutOfWorld) notCollidedEnemies
            nnparticles = filter (not <<< isOutOfWorld) nparticles
            nnenemyBullets = filter (not <<< isOutOfWorld) nenemyBullets

        -- game condition
        let isGameOver = isHazardColl || isEnemyColl || isEnemyBulletColl
            isCatchOct (Oct _) = true
            isCatchOct _ = false  
            isGameClear = any isCatchOct collidedEnemies

        pure $ case isGameClear, isGameOver of
            true, _ -> ClearState
            false, true -> OverState
            false, false -> PlayState $ s { 
                distance = s.distance, 
                player = nnp, 
                bullets = nnbullets <> newBullets, 
                enemies = nnenemies <> newEnemies, 
                particles = nnparticles <> newParticles, 
                enemyBullets = nnenemyBullets <> newEnemyBullets,
                mapId = s.mapId
            }

    draw TitleState = do
        drawScaledImage I.titleScreen 0 0
    draw OverState = do
        cls Maroon
        emo E.hole 256 125 150
        emor 160 E.helicopter 128 175 200
        emo E.recyclingSymbol 128 185 350
    draw ClearState = do
        cls Lime
        emor 15 E.helicopter 64 350 400
        emor (-15) E.octopus 128 175 175
        emo E.globeWithMeridians 256 75 75
        emo E.thumbsUp 64 100 400
    draw (PlayState s) = do
        drawScaledImage I.blackBackground 0 0
        drawScrollMap s.distance s.mapId
        draw s.player
        traverse_ draw s.bullets
        traverse_ draw s.enemies
        traverse_ draw s.particles
        traverse_ draw s.enemyBullets

    sound _ = pure unit

initialPlayState :: State
initialPlayState = PlayState { 
    distance: 0, 
    player: initialPlayer, 
    bullets: [], 
    enemies: [], 
    particles: [], 
    enemyBullets : [],
    mapId: 0
}

initialState :: State
initialState = TitleState

main :: Effect Unit
main = do
    asset <- mkAsset allRawLevels []
    emo8 initialState asset defaultMonitorSize
