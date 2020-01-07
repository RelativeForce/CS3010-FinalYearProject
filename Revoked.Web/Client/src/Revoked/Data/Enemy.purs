module Data.Enemy where

import Prelude

import Class.Object (class ObjectDraw, class Object, position, draw)
import Data.Bullet (Bullet)
import Data.Enemy.Marine (Marine, updateMarine, defaultMarine)
import Data.Player (Player)
import Emo8.Action.Draw (drawSprite)
import Emo8.Types (Position, Score, X)

data Enemy = EnemyMarine Marine

instance objectEnemy :: Object Enemy where
    size (EnemyMarine s) = s.sprite.size
    position (EnemyMarine s) = s.pos
    scroll offset (EnemyMarine s) = EnemyMarine $ s { pos = { x: s.pos.x + offset, y: s.pos.y }}

instance objectDrawEnemy :: ObjectDraw Enemy where
    draw o@(EnemyMarine m) = do 
        drawSprite m.sprite (position o).x (position o).y
        draw m.gun

enemyToScore :: Enemy -> Score
enemyToScore (EnemyMarine s) = 9

updateEnemy :: (Enemy -> Boolean) -> X -> Player -> Enemy -> { enemy :: Enemy, bullets :: Array Bullet }
updateEnemy collisionCheck distance playerObject (EnemyMarine marine) = (toEnemyAndBullets (EnemyMarine)) $ updateMarine (toMarineCollision collisionCheck) distance playerObject marine

defaultMarineEnemy :: Position -> Enemy
defaultMarineEnemy = defaultMarine >>> EnemyMarine

toMarineCollision :: (Enemy -> Boolean) -> Marine -> Boolean
toMarineCollision check = check <<< EnemyMarine

toEnemyAndBullets :: forall a. (a -> Enemy) -> { enemy :: a, bullets :: Array Bullet } -> { enemy :: Enemy, bullets :: Array Bullet }
toEnemyAndBullets mapper r = { enemy: mapper r.enemy, bullets: r.bullets }