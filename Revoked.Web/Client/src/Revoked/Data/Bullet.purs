module Data.Bullet where

import Prelude

import Class.Object (class ObjectDraw, class Object)
import Emo8.Action.Draw (drawRotatedSprite)
import Data.Int (floor)
import Assets.Sprites as S
import Emo8.Types (Position, Sprite, Velocity)
import Emo8.Data.Sprite (incrementFrame)
import Emo8.Utils (angle, toPosition)

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
    draw (Bullet b) = drawRotatedSprite b.sprite b.pos.x b.pos.y $ mod (angle (toPosition b.velocity)) 180

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