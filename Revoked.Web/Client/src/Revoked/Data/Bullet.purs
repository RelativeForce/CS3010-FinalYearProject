module Data.Bullet where

import Prelude

import Class.Object (class ObjectDraw, class Object)
import Emo8.Action.Draw (drawSprite)
import Data.Int (floor)
import Assets.Sprites as S
import Emo8.Types (Position, Sprite, Velocity)
import Emo8.Data.Sprite (incrementFrame)

data Bullet = Bullet { 
    pos :: Position,
    sprite :: Sprite,
    velocity :: Velocity
}

instance objectBullet :: Object Bullet where
    size (Bullet b) = b.sprite.size
    position (Bullet b) = b.pos
    scroll offset (Bullet b) = Bullet $ b { pos = { x: b.pos.x + offset, y: b.pos.y }}

instance objectDrawBullet :: ObjectDraw Bullet where
    draw (Bullet b) = drawSprite b.sprite b.pos.x b.pos.y

updateBullet :: Bullet -> Bullet
updateBullet (Bullet b) = Bullet $ b { pos = newPos, sprite = newSprite }
    where
        newPos = {
            x: b.pos.x + floor b.velocity.xSpeed,
            y: b.pos.y + floor b.velocity.ySpeed
        } 
        newSprite = incrementFrame b.sprite

newBullet :: Position -> Velocity -> Bullet
newBullet pos velocity = Bullet $ {
    pos: pos,
    velocity: velocity,
    sprite: S.pistolBullet 
}