module Data.Bullet where

import Prelude

import Class.Object (class ObjectDraw, class Object)
import Emo8.Action.Draw (drawSprite)
import Data.Sprites as S
import Emo8.Types (Position, Sprite)

data BulletAppear = Forward | Backward

data Bullet = Bullet { 
    pos :: Position,
    appear :: BulletAppear,
    sprite :: Sprite
}

instance objectBullet :: Object Bullet where
    size (Bullet s) = s.sprite.size
    position (Bullet s) = s.pos

instance objectDrawBullet :: ObjectDraw Bullet where
    draw (Bullet b) = drawSprite b.sprite b.pos.x b.pos.y

updateBullet :: Int -> Bullet -> Bullet
updateBullet scrollOffset (Bullet s) = Bullet $ s { pos { x = newX } }
    where
        newX = scrollOffset + case s.appear of
            Forward -> s.pos.x + bulletSpeed
            Backward -> s.pos.x - bulletSpeed

newBullet :: BulletAppear -> Position -> Bullet
newBullet appear pos = Bullet $ {
    pos: pos,
    appear: appear,
    sprite: case appear of
        Forward -> S.bulletRight
        Backward -> S.bulletLeft
}

bulletSpeed :: Int
bulletSpeed = 8