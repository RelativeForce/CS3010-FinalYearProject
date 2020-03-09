module Revoked.Data.Bullet where

import Prelude

import Data.Int (floor)

import Emo8.Types (Position, Sprite, Velocity, Deg)
import Emo8.Data.Sprite (incrementFrame)
import Emo8.Utils (xComponent, yComponent)
import Emo8.Class.Object (class ObjectDraw, class Object)
import Emo8.Action.Draw (drawSprite)

import Revoked.Assets.Sprites as S
import Revoked.Constants (gravity, bulletSpeed)

-- | Represents a bullet 
type BaseBullet = { 
    pos :: Position,
    sprite :: Sprite,
    velocity :: Velocity
}

-- | Represents the different types of bullet.
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

-- | Updates a bullet based on its current trajectory.
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
        -- Apply gravity to the bullet's velocity
        newVelocity = b.velocity { ySpeed = b.velocity.ySpeed + gravity }
        newSprite = incrementFrame b.sprite

-- | Build the velocity of a bullet traveling with the bullets constant speed at 
-- | the given angle.
toBulletVelocity :: Deg -> Velocity
toBulletVelocity angle = velocity
    where
        velocity = {
            xSpeed: xComponent angle bulletSpeed,
            ySpeed: yComponent angle bulletSpeed
        }

-- | Builds a new linear bullet with a given `Position` and `Velocity`.
newLinearBullet :: Position -> Velocity -> Bullet
newLinearBullet pos velocity = LinearBullet $ {
    pos: pos,
    velocity: velocity,
    sprite: S.pistolBullet 
}

-- | Builds a new arcing bullet with a given `Position` and initial `Velocity`.
newArcBullet :: Position -> Velocity -> Bullet
newArcBullet pos velocity = ArcBullet $ {
    pos: pos,
    velocity: velocity,
    sprite: S.pistolBullet 
}