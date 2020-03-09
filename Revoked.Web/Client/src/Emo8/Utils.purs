module Emo8.Utils where

import Prelude

import Data.Int (toNumber, floor)
import Math (sqrt, atan, pi, abs, cos, sin)

import Emo8.Types (Position, Velocity, Deg, Vector)

-- | The xor operation between two booleans
xor :: Boolean -> Boolean -> Boolean
xor a b = (not a && b) || (not b && a)

-- | The distance a given `Position` is from the Origin aka (x: 0, y: 0)
distanceFromOrigin :: Position -> Number
distanceFromOrigin p = sqrt $ toNumber $ (p.x * p.x) + (p.y * p.y)

-- | The direction-less speed defined by the given `Velocity` 
magnitude :: Velocity -> Number
magnitude v = sqrt $ (v.xSpeed * v.xSpeed) + (v.ySpeed * v.ySpeed)

-- | The vector between two `Position`s
vectorTo :: Position -> Position -> Vector
vectorTo positionA positionB = { x: positionB.x - positionA.x, y: positionB.y - positionA.y }

-- | Normalises a velocity such that it has unit speed.
normalise :: Velocity -> Velocity
normalise v = { xSpeed: v.xSpeed / s, ySpeed: v.ySpeed / s } 
    where
        s = (abs v.xSpeed) + (abs v.ySpeed)

-- | Caculates the distance between two `Position`s
distanceBetween :: Position -> Position -> Number
distanceBetween a b = distanceFromOrigin $ vectorTo a b

-- | Combines two `Vector`s
sum :: Vector -> Vector -> Vector
sum a b = { x: a.x + b.x, y: a.y + b.y }

-- | Determines the horizontal component of a vector at the specified angle and with 
-- | the specified magnitude.
xComponent :: Deg -> Number -> Number
xComponent a length = length * (cos $ degToRadians a)

-- | Determines the vertical component of a vector at the specified angle and with 
-- | the specified magnitude.
yComponent :: Deg -> Number -> Number
yComponent a length = length * (sin $ degToRadians a)

-- | Converts degrees into Radians
degToRadians :: Deg -> Number
degToRadians d = (pi * toNumber d) / 180.0

-- | Converts Radians into Degrees
radiansToDeg :: Number -> Deg
radiansToDeg r = floor $ (180.0 * r) / pi

-- | Whether or not an vector at the given angle is pointed left.
inLeftDirection :: Deg -> Boolean
inLeftDirection d = d > 90 && d < 270

-- | Determines the angle of a given `Vector` from the positive horizontal axis.
-- | NOTE: Rotation is anti-clockwise from the positive x axis
angle :: Vector -> Deg
angle v = mod angleBasedOnDirection 360
    where
        angleFromHorizontalAxis = radiansToDeg $ atan $ (toNumber v.y) / (toNumber v.x)
        isRight = v.x > 0
        isUp = v.y > 0
        isDown = v.y < 0
        isLeft = v.x < 0
        angleBasedOnDirection = case isRight, isDown, isLeft, isUp of
            false, true, true, false -> 180 + angleFromHorizontalAxis
            false, false, true, true -> 180 + angleFromHorizontalAxis
            false, true, false, false -> 270
            false, false, false, true -> 90
            false, false, true, false -> 180
            true, false, false, false -> 0
            false, false, false, false -> 0
            _, _, _, _ -> angleFromHorizontalAxis

-- | Applies a given `Velocity` to a given `Position`
updatePosition :: Position -> Velocity -> Position
updatePosition p v = { x: x, y: y }
    where
        x = floor $ (toNumber p.x) + v.xSpeed
        y = floor $ (toNumber p.y) + v.ySpeed
