module Data.Enemy where

import Prelude

import Class.Object (class ObjectDraw, class Object, class MortalEntity, position, draw, scroll)
import Data.Bullet (Bullet)
import Data.Enemy.Marine (Marine, updateMarine, defaultMarine)
import Data.Player (Player)
import Emo8.Action.Draw (drawSprite)
import Data.Helper (drawHealth)
import Emo8.Types (Position, Score, X)

data Enemy = EnemyMarine Marine

instance objectEnemy :: Object Enemy where
    size (EnemyMarine s) = s.sprite.size
    position (EnemyMarine s) = s.pos
    scroll offset (EnemyMarine s) = EnemyMarine $ s { pos = { x: s.pos.x + offset, y: s.pos.y }, gun = scroll offset s.gun }

instance objectDrawEnemy :: ObjectDraw Enemy where
    draw o@(EnemyMarine m) = do 
        drawSprite m.sprite (position o).x (position o).y
        draw m.gun
        drawHealth o

instance mortalEntityPlayer :: MortalEntity Enemy where
    health (EnemyMarine m) = m.health
    damage (EnemyMarine m) healthLoss = EnemyMarine $ m { health = m.health - healthLoss }
    heal (EnemyMarine m) healthBonus = EnemyMarine $ m { health = m.health + healthBonus }

enemyToScore :: Enemy -> Score
enemyToScore (EnemyMarine s) = 9

updateEnemy :: (Enemy -> Boolean) -> X -> Player -> Enemy -> { enemy :: Enemy, bullets :: Array Bullet }
updateEnemy collisionCheck distance playerObject (EnemyMarine marine) = (toEnemyAndBullets (EnemyMarine)) $ updateMarine (toMarineCollision collisionCheck) distance playerObject marine

defaultMarineEnemy :: Int -> Position -> Enemy
defaultMarineEnemy initialHealth pos = EnemyMarine $ defaultMarine initialHealth pos

toMarineCollision :: (Enemy -> Boolean) -> Marine -> Boolean
toMarineCollision check = check <<< EnemyMarine

toEnemyAndBullets :: forall a. (a -> Enemy) -> { enemy :: a, bullets :: Array Bullet } -> { enemy :: Enemy, bullets :: Array Bullet }
toEnemyAndBullets mapper r = { enemy: mapper r.enemy, bullets: r.bullets }