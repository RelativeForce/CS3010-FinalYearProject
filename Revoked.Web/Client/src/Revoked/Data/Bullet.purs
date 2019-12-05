module Data.Bullet where

import Prelude

import Class.Object (class ObjectDraw, class Object)
import Emo8.Action.Draw (drawSprite)
import Data.Int (floor)
import Assets.Sprites as S
import Emo8.Types (Position, Sprite, Size)
import Emo8.Data.Sprite (incrementFrame)
import Constants (bulletSpeed)

data BulletAppear = BulletForward | BulletBackward

data Bullet = Bullet { 
    pos :: Position,
    appear :: BulletAppear,
    sprite :: Sprite
}

instance objectBullet :: Object Bullet where
    size (Bullet s) = s.sprite.size
    position (Bullet s) = s.pos
    scroll offset (Bullet s) = Bullet $ s { pos = { x: s.pos.x + offset, y: s.pos.y }}

instance objectDrawBullet :: ObjectDraw Bullet where
    draw (Bullet b) = drawSprite b.sprite b.pos.x b.pos.y

updateBullet :: Bullet -> Bullet
updateBullet (Bullet s) = Bullet $ s { pos { x = newX }, sprite = newSprite }
    where
        newX = case s.appear of
            BulletForward -> s.pos.x + floor bulletSpeed
            BulletBackward -> s.pos.x - floor bulletSpeed
        newSprite = incrementFrame s.sprite

newBullet :: BulletAppear -> Position -> Size -> Bullet
newBullet appear pos size = Bullet $ {
    pos: pos {
        y = pos.y + (size.height / 2)
    },
    appear: appear,
    sprite: case appear of
        BulletForward -> S.bulletRight
        BulletBackward -> S.bulletLeft
}