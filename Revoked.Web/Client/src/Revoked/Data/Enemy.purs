module Data.Enemy where

import Prelude

import Class.Object (class ObjectDraw, class Object, position)
import Data.EnemyBullet (EnemyBullet(..))
import Data.Player (Player(..))
import Emo8.Action.Draw (drawSprite)
import Assets.Sprites as S
import Data.Enemy.Marine (Marine, MarineAppear(..), updateMarine)
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
addEnemyBullet (Player p) (EnemyMarine e) = []

updateEnemy :: (Enemy -> Boolean) -> X -> Player -> Enemy -> Enemy
updateEnemy collisionCheck distance playerObject (EnemyMarine marine) = EnemyMarine $ updateMarine (toMarineCollision collisionCheck) distance playerObject marine

defaultMarine :: Position -> Enemy
defaultMarine pos = EnemyMarine {
    pos: pos,
    sprite: S.marineLeft,
    appear: WalkingLeft,
    velocity: {
        xSpeed: 0.0,
        ySpeed: 0.0
    },
    shotCoolDown: 0
}

toMarineCollision :: (Enemy -> Boolean) -> Marine -> Boolean
toMarineCollision check = check <<< EnemyMarine