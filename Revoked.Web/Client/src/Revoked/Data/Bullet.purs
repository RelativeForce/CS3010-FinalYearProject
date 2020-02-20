module Data.Bullet where

import Prelude

import Class.Object (class ObjectDraw, class Object)
import Emo8.Action.Draw (drawSprite)
import Data.Int (floor)
import Assets.Sprites as S
import Emo8.Types (Position, Sprite, Velocity)
import Emo8.Data.Sprite (incrementFrame)
import Constants (gravity)

type BaseBullet = { 
    pos :: Position,
    sprite :: Sprite,
    velocity :: Velocity
}

data Bullet = 
    LinearBullet BaseBullet | 
    ArcBullet BaseBullet

instance objectBullet :: Object Bullet where
    size (LinearBullet b) = b.sprite.size
    size (ArcBullet b) = b.sprite.size
    position (LinearBullet b) = b.pos
    position (ArcBullet b) = b.pos
    scroll offset (LinearBullet b) = LinearBullet $ b { pos = { x: b.pos.x + offset, y: b.pos.y }}
    scroll offset (ArcBullet b) = ArcBullet $ b { pos = { x: b.pos.x + offset, y: b.pos.y }}


instance objectDrawBullet :: ObjectDraw Bullet where
    draw (LinearBullet b) = drawSprite b.sprite b.pos.x b.pos.y
    draw (ArcBullet b) = drawSprite b.sprite b.pos.x b.pos.y

updateBullet :: Bullet -> Bullet
updateBullet (LinearBullet b) = LinearBullet $ b { pos = newPos, sprite = newSprite }
    where
        newPos = {
            x: b.pos.x + floor b.velocity.xSpeed,
            y: b.pos.y + floor b.velocity.ySpeed
        } 
        newSprite = incrementFrame b.sprite
updateBullet (ArcBullet b) = ArcBullet $ b { pos = newPos, sprite = newSprite, velocity = newVelocity }
    where
        newVelocity = b.velocity { ySpeed = b.velocity.ySpeed + gravity }
        newPos = {
            x: b.pos.x + floor newVelocity.xSpeed,
            y: b.pos.y + floor newVelocity.ySpeed
        } 
        newSprite = incrementFrame b.sprite

newLinearBullet :: Position -> Velocity -> Bullet
newLinearBullet pos velocity = LinearBullet $ {
    pos: pos,
    velocity: velocity,
    sprite: S.pistolBullet 
}

newArcBullet :: Position -> Velocity -> Bullet
newArcBullet pos velocity = ArcBullet $ {
    pos: pos,
    velocity: velocity,
    sprite: S.pistolBullet 
}