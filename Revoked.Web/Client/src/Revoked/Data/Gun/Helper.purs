module Revoked.Data.Gun.Helper where

import Prelude

import Data.Int (toNumber, floor)

import Emo8.Types (Position, Deg, Size)
import Emo8.Utils (xComponent, yComponent, inLeftDirection)

import Revoked.Data.Bullet (Bullet, newLinearBullet, toBulletVelocity)

-- | Defines the directions that a gun can be facing
data GunAppear = Left | Right 

instance gunAppearEqual :: Eq GunAppear where
    eq (Left) (Left) = true
    eq (Right) (Right) = true
    eq _ _ = false

instance gunAppearShow :: Show GunAppear where
    show (Left) = "Left"
    show (Right) = "Right"

-- | Determines a bullets position based on the position and the rotation of the gun.
bulletPosition :: Deg -> Position -> Size -> Position
bulletPosition angle pos size = { x: x, y: y }
    where 
        x = if inLeftDirection angle
                then pos.x + floor (xComponent angle (toNumber size.width))
                else pos.x + floor (xComponent angle (toNumber size.width))
        y = if inLeftDirection angle
                then pos.y + size.height + (floor (yComponent angle (toNumber size.width)))
                else pos.y + floor (yComponent angle (toNumber size.width))

-- | Maps an angle of a gun into the direction the gun should appear
appearBasedOnAngle :: Deg -> GunAppear
appearBasedOnAngle angle = if inLeftDirection angle then Left else Right

-- | Builds a new gun bullet with a given position and velocity based on the 
-- | specified angle.
newGunBullet :: Deg -> Position -> Size -> Bullet
newGunBullet angle pos s = bullet
    where
        velocity = toBulletVelocity angle
        position = bulletPosition angle pos s
        bullet = newLinearBullet position velocity 