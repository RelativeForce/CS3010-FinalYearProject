module Data.Enemy where

import Prelude

import Class.Object (class ObjectDraw, class Object, position)
import Data.EnemyBullet (EnemyBullet)
import Data.Player (Player)
import Emo8.Action.Draw (drawSprite)
import Data.Enemy.Marine (Marine, updateMarine, addMarineBullet, defaultMarine)
import Emo8.Types (Position, Score, X)

data Enemy = EnemyMarine Marine

instance objectEnemy :: Object Enemy where
    size (EnemyMarine s) = s.sprite.size
    position (EnemyMarine s) = s.pos
    scroll offset (EnemyMarine s) = EnemyMarine $ s { pos = { x: s.pos.x + offset, y: s.pos.y }}

instance objectDrawEnemy :: ObjectDraw Enemy where
    draw o@(EnemyMarine m) = drawSprite m.sprite (position o).x (position o).y

enemyToScore :: Enemy -> Score
enemyToScore (EnemyMarine s) = 9

addEnemyBullet :: Player -> Enemy -> Array EnemyBullet
addEnemyBullet p (EnemyMarine m) = addMarineBullet p m

updateEnemy :: (Enemy -> Boolean) -> X -> Player -> Enemy -> Enemy
updateEnemy collisionCheck distance playerObject (EnemyMarine marine) = EnemyMarine $ updateMarine (toMarineCollision collisionCheck) distance playerObject marine

defaultMarineEnemy :: Position -> Enemy
defaultMarineEnemy = defaultMarine >>> EnemyMarine

toMarineCollision :: (Enemy -> Boolean) -> Marine -> Boolean
toMarineCollision check = check <<< EnemyMarine