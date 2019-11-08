module Revoked where

import Prelude

import Levels (allRawLevels, emergeTable, goals, levelCount)
import Class.Object (draw, position)
import Collision (isCollideObjects, isOutOfWorld)
import Data.Array (any, filter, partition)
import Data.Bullet (Bullet, updateBullet)
import Data.Enemy (Enemy, addEnemyBullet, updateEnemy)
import Data.EnemyBullet (EnemyBullet, updateEnemyBullet)
import Data.Foldable (traverse_)
import Data.Particle (Particle, initParticle, updateParticle)
import Data.Player (Player, addBullet, initialPlayer, updatePlayer)
import Data.Goal (Goal, updateGoal)
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
    TitleScreen
    | GameOver
    | Victory
    | Play { 
        distance :: Int, 
        player :: Player, 
        bullets :: Array Bullet, 
        enemies :: Array Enemy, 
        particles :: Array Particle, 
        enemyBullets :: Array EnemyBullet,
        goals :: Array Goal,
        mapId :: MapId
    }

instance gameState :: Game State where
    update input TitleScreen =
        pure $ if isCatchAny input then newLevel 0 else TitleScreen
    update input GameOver =
        pure $ if isCatchAny input then initialState else GameOver
    update input Victory =
        pure $ if isCatchAny input then initialState else Victory
    update input (Play s) = do

        -- update player
        updatedPlayer <- updatePlayer input s.player s.distance (isCollideMapWalls s.mapId s.distance)

        let 
            newDistance = adjustMonitorDistance updatedPlayer s.distance
            scrollOffset = (s.distance - newDistance)
            np = adjustPlayerPos updatedPlayer scrollOffset
            nbullets = map (updateBullet scrollOffset) s.bullets
            nenemies = map (updateEnemy scrollOffset s.player) s.enemies
            ngoals = map updateGoal s.goals
            nparticles = map (updateParticle scrollOffset) s.particles
            nenemyBullets = map (updateEnemyBullet scrollOffset) s.enemyBullets

        -- player collision
        isHazardColl <- isCollideMapHazards s.mapId s.distance np

        let isEnemyColl = any (isCollideObjects np) nenemies
            isEnemyBulletColl = any (isCollideObjects np) nenemyBullets
            isGoalColl = any (isCollideObjects np) s.goals

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
            isNextLevel = isGoalColl

        pure $ case isGameOver, isNextLevel of
            true, _ -> GameOver
            false, true -> if s.mapId + 1 >= levelCount then Victory else newLevel (s.mapId + 1)
            false, false -> Play $ s { 
                distance = newDistance, 
                player = np, 
                bullets = nnbullets <> newBullets, 
                enemies = nnenemies <> newEnemies, 
                particles = nnparticles <> newParticles, 
                enemyBullets = nnenemyBullets <> newEnemyBullets,
                goals = ngoals,
                mapId = s.mapId
            }

    draw TitleScreen = do
        drawScaledImage I.titleScreen 0 0
    draw GameOver = do
        cls Maroon
    draw Victory = do
        cls Lime
    draw (Play s) = do
        drawScaledImage I.blackBackground 0 0
        drawScrollMap s.distance s.mapId
        draw s.player
        traverse_ draw s.bullets
        traverse_ draw s.enemies
        traverse_ draw s.particles
        traverse_ draw s.enemyBullets
        traverse_ draw s.goals

    sound _ = pure unit

newLevel :: MapId -> State
newLevel mapId = Play { 
    distance: 0, 
    player: initialPlayer, 
    bullets: [], 
    enemies: [], 
    particles: [], 
    enemyBullets : [],
    goals: goals mapId,
    mapId: mapId
}

initialState :: State
initialState = TitleScreen

main :: Effect Unit
main = do
    asset <- mkAsset allRawLevels []
    emo8 initialState asset defaultMonitorSize
