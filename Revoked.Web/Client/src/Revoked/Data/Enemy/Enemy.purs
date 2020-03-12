module Revoked.Data.Enemy where

import Prelude

import Emo8.Class.Object (class ObjectDraw, class Object, position, draw, scroll)
import Emo8.Action.Draw (drawSprite)
import Emo8.Types (Position, Score, X)

import Revoked.Class.MortalEntity (class MortalEntity)
import Revoked.Data.Bullet (Bullet)
import Revoked.Data.Enemy.BigBertha (BigBertha, defaultBigBertha, updateBigBertha, damageBigBertha)
import Revoked.Data.Enemy.Drone (Drone, defaultDrone, updateDrone)
import Revoked.Data.Enemy.Marine (Marine, updateMarine, defaultMarine)
import Revoked.Data.Draw (drawHealth)
import Revoked.Data.Player (Player)

-- | Wraps the different types of Enemy
data Enemy = 
    EnemyMarine Marine |
    EnemyDrone Drone |
    EnemyBigBertha BigBertha

instance objectEnemy :: Object Enemy where
    size (EnemyMarine s) = s.sprite.size
    size (EnemyDrone s) = s.sprite.size
    size (EnemyBigBertha s) = s.sprite.size
    position (EnemyMarine s) = s.pos
    position (EnemyDrone s) = s.pos
    position (EnemyBigBertha s) = position s.phase
    scroll offset (EnemyMarine s) = EnemyMarine $ s { pos = { x: s.pos.x + offset, y: s.pos.y }, gun = scroll offset s.gun }
    scroll offset (EnemyDrone s) = EnemyDrone $ s { pos = { x: s.pos.x + offset, y: s.pos.y }, gun = scroll offset s.gun }
    scroll offset (EnemyBigBertha s) = EnemyBigBertha $ s { phase = scroll offset s.phase }

instance objectDrawEnemy :: ObjectDraw Enemy where
    draw o@(EnemyMarine m) = do 
        drawSprite m.sprite (position o).x (position o).y
        draw m.gun
        drawHealth o
    draw o@(EnemyDrone m) = do 
        draw m.gun
        drawSprite m.sprite (position o).x (position o).y
        drawHealth o
    draw o@(EnemyBigBertha m) = do
        drawSprite m.sprite (position m.phase).x (position m.phase).y
        drawHealth o

instance mortalEntityPlayer :: MortalEntity Enemy where
    health (EnemyMarine m) = m.health
    health (EnemyDrone m) = m.health
    health (EnemyBigBertha m) = m.health
    damage (EnemyMarine m) healthLoss = EnemyMarine $ m { health = m.health - healthLoss }
    damage (EnemyDrone m) healthLoss = EnemyDrone $ m { health = m.health - healthLoss }
    damage (EnemyBigBertha m) healthLoss = EnemyBigBertha $ damageBigBertha m healthLoss
    heal (EnemyMarine m) healthBonus = EnemyMarine $ m { health = m.health + healthBonus }
    heal (EnemyDrone m) healthBonus = EnemyDrone $ m { health = m.health + healthBonus }
    heal (EnemyBigBertha m) healthBonus = EnemyBigBertha $ m { health = m.health + healthBonus }

-- | Maps an enemy into the score rewarded for killing that enemy
enemyToScore :: Enemy -> Score
enemyToScore (EnemyMarine _) = 9
enemyToScore (EnemyDrone _) = 15
enemyToScore (EnemyBigBertha _) = 100

-- | Updates the specified enemy based on the given `Player` and map collision function
updateEnemy :: (Enemy -> Boolean) -> X -> Player -> Enemy -> { enemy :: Enemy, bullets :: Array Bullet }
updateEnemy collisionCheck distance playerObject (EnemyMarine marine) = (toEnemyAndBullets (EnemyMarine)) $ updateMarine (collisionCheck <<< EnemyMarine) distance playerObject marine
updateEnemy collisionCheck distance playerObject (EnemyDrone drone) = (toEnemyAndBullets (EnemyDrone)) $ updateDrone distance playerObject drone
updateEnemy collisionCheck distance playerObject (EnemyBigBertha bigBertha) = (toEnemyAndBullets (EnemyBigBertha)) $ updateBigBertha distance playerObject bigBertha

-- | Builds a `Marine` with a specified `Position` and initial health
defaultMarineEnemy :: Int -> Position -> Enemy
defaultMarineEnemy initialHealth pos = EnemyMarine $ defaultMarine initialHealth pos

-- | Builds a `Drone` with a specified `Position` and initial health
defaultDroneEnemy :: Int -> Position -> Position -> Enemy
defaultDroneEnemy initialHealth leftLimit rightLimit = EnemyDrone $ defaultDrone initialHealth leftLimit rightLimit

-- | Builds a `BigBertha` with specified left and right limit `Position`s
defaultBigBerthaEnemy :: Position -> Position -> Enemy
defaultBigBerthaEnemy leftLimit rightLimit = EnemyBigBertha $ defaultBigBertha leftLimit rightLimit

-- | Maps any type of Enemy and bullets pair into a Enemy and bullets pair using the specified mapper function. 
toEnemyAndBullets :: forall a. (a -> Enemy) -> { enemy :: a, bullets :: Array Bullet } -> { enemy :: Enemy, bullets :: Array Bullet }
toEnemyAndBullets mapper r = { enemy: mapper r.enemy, bullets: r.bullets }