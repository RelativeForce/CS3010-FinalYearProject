module Emo8.Utils where

import Prelude

import Data.Int (toNumber, floor)
import Math (sqrt, atan, pi, abs, cos, sin)

import Emo8.Types (Position, Velocity, Deg, Vector)

xor :: Boolean -> Boolean -> Boolean
xor a b = (not a && b) || (not b && a)

distanceFromOrigin :: Position -> Number
distanceFromOrigin p = sqrt $ toNumber $ (p.x * p.x) + (p.y * p.y)

magnitude :: Velocity -> Number
magnitude v = sqrt $ (v.xSpeed * v.xSpeed) + (v.ySpeed * v.ySpeed)

vectorTo :: Position -> Position -> Vector
vectorTo positionA positionB = { x: positionB.x - positionA.x, y: positionB.y - positionA.y }

toPosition :: Velocity -> Position
toPosition v = { x: floor v.xSpeed, y: floor v.ySpeed }

toVelocity :: Position -> Velocity
toVelocity p = { xSpeed: (toNumber p.x), ySpeed: (toNumber p.y)  } 

normalise :: Velocity -> Velocity
normalise v = { xSpeed: v.xSpeed / s, ySpeed: v.ySpeed / s } 
    where
        s = (abs v.xSpeed) + (abs v.ySpeed)

distanceBetween :: Position -> Position -> Number
distanceBetween a b = distanceFromOrigin $ vectorTo a b

sum :: Vector -> Vector -> Vector
sum a b = { x: a.x + b.x, y: a.y + b.y }

xComponent :: Deg -> Number -> Number
xComponent a length = length * (cos $ degToRadians a)

yComponent :: Deg -> Number -> Number
yComponent a length = length * (sin $ degToRadians a)

degToRadians :: Deg -> Number
degToRadians d = (pi * toNumber d) / 180.0

radiansToDeg :: Number -> Deg
radiansToDeg r = floor $ (180.0 * r) / pi

inLeftDirection :: Deg -> Boolean
inLeftDirection d = d > 90 && d < 270

-- | Rotation is anti-clockwise from the positive x axis
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

updatePosition :: Position -> Velocity -> Position
updatePosition p v = { x: x, y: y }
    where
        x = floor $ (toNumber p.x) + v.xSpeed
        y = floor $ (toNumber p.y) + v.ySpeed
