module Data.Gun.Helper where

import Prelude

import Emo8.Types (Position, Deg, Size)
import Revoked.Data.Bullet (Bullet, newLinearBullet, toBulletVelocity)
import Emo8.Utils (xComponent, yComponent, inLeftDirection)
import Data.Int (toNumber, floor)

data GunAppear = Left | Right 

instance gunAppearEqual :: Eq GunAppear where
    eq (Left) (Left) = true
    eq (Right) (Right) = true
    eq _ _ = false

instance gunAppearShow :: Show GunAppear where
    show (Left) = "Left"
    show (Right) = "Right"

bulletPosition :: Deg -> Position -> Size -> Position
bulletPosition angle pos size = { x: x, y: y }
    where 
        x = if inLeftDirection angle
                then pos.x + floor (xComponent angle (toNumber size.width))
                else pos.x + floor (xComponent angle (toNumber size.width))
        y = if inLeftDirection angle
                then pos.y + size.height + (floor (yComponent angle (toNumber size.width)))
                else pos.y + floor (yComponent angle (toNumber size.width))

appearBasedOnAngle :: Deg -> GunAppear
appearBasedOnAngle angle = if inLeftDirection angle then Left else Right

newGunBullet :: Deg -> Position -> Size -> Bullet
newGunBullet angle pos s = bullet
    where
        velocity = toBulletVelocity angle
        position = bulletPosition angle pos s
        bullet = newLinearBullet position velocity 