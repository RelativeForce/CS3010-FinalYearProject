module Data.Bullet where

import Prelude

import Emo8.Class.Object (class ObjectDraw, class Object)
import Emo8.Action.Draw (drawSprite)
import Data.Int (floor)
import Revoked.Assets.Sprites as S
import Emo8.Types (Position, Sprite, Velocity, Deg)
import Emo8.Data.Sprite (incrementFrame)
import Emo8.Utils (xComponent, yComponent)
import Revoked.Constants (gravity, bulletSpeed)

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
        newPos = {
            x: b.pos.x + floor b.velocity.xSpeed,
            y: b.pos.y + floor b.velocity.ySpeed
        } 
        newVelocity = b.velocity { ySpeed = b.velocity.ySpeed + gravity }
        newSprite = incrementFrame b.sprite

toBulletVelocity :: Deg -> Velocity
toBulletVelocity angle = velocity
    where
        velocity = {
            xSpeed: xComponent angle bulletSpeed,
            ySpeed: yComponent angle bulletSpeed
        }

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