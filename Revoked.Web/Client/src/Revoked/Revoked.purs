module Revoked where

import Prelude

import Levels (allRawLevels, emergeTable)
import Class.Object (draw, position)
import Collision (isCollideObjects, isOutOfWorld)
import Data.Array (any, filter, partition)
import Data.Bullet (Bullet, updateBullet)
import Data.Enemy (Enemy(..), addEnemyBullet, updateEnemy)
import Data.EnemyBullet (EnemyBullet, updateEnemyBullet)
import Data.Foldable (traverse_)
import Data.Particle (Particle, initParticle, updateParticle)
import Data.Player (Player, addBullet, initialPlayer, updatePlayer )
import Effect (Effect)
import Emo8 (emo8)
import Emo8.Action.Draw (cls, drawScaledImage)
import Assets.Images as I
import Emo8.Class.Game (class Game)
import Emo8.Data.Color (Color(..))
import Emo8.Types (MapId)
import Emo8.Input (isCatchAny)
import Emo8.Utils (defaultMonitorSize, mkAsset)
import Helper (drawScrollMap, isCollideMapWalls, isCollideMapHazards, adjustMonitorDistance, adjustPlayerPos)

data State = 
    TitleState
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

        -- update player
        updatedPlayer <- updatePlayer input s.player s.distance (isCollideMapWalls s.mapId s.distance)

        let 
            newDistance = adjustMonitorDistance updatedPlayer s.distance
            scrollOffset = (s.distance - newDistance)
            np = adjustPlayerPos updatedPlayer scrollOffset
            nbullets = map (updateBullet scrollOffset) s.bullets
            nenemies = map (updateEnemy scrollOffset s.player) s.enemies
            nparticles = map (updateParticle scrollOffset) s.particles
            nenemyBullets = map (updateEnemyBullet scrollOffset) s.enemyBullets

        -- player collision
        isHazardColl <- isCollideMapHazards s.mapId s.distance np

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
                distance = newDistance, 
                player = np, 
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
    draw ClearState = do
        cls Lime
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
