module Revoked.Data.Enemy.BigBertha.Helper where

import Prelude

import Data.Int (floor)

import Emo8.Types (Position, Velocity, X)
import Emo8.Utils (distanceBetween)

import Revoked.Constants (bigBerthaSpeed, bigBerthaAgroRange)
import Revoked.Data.Player (Player(..))

-- | Whether the specified player is within range of a BigBertha at the specified `Position`.
playerInRange :: Player -> Position -> Boolean
playerInRange (Player p) pos = bigBerthaAgroRange > distanceBetween p.pos pos

-- | Updates the `Velocity` of a phase of BigBertha based on its current `Position` and `Velocity`
updateVelocity :: X -> Position -> Position -> Position -> Velocity -> Velocity
updateVelocity distance leftLimit rightLimit currentPosition currentVelocity = { xSpeed: xSpeed, ySpeed: 0.0 }
    where
        newX = currentPosition.x + floor currentVelocity.xSpeed
        xSpeed = if (newX + distance) < leftLimit.x 
            then 0.0 
            else if (newX + distance) > rightLimit.x 
                then -bigBerthaSpeed 
                else currentVelocity.xSpeed

-- | Updates the `Position` of a phase of BigBertha based on its current `Position` and `Velocity`
updatePosition :: X -> Position -> Position -> Position -> Velocity -> Position
updatePosition distance leftLimit rightLimit currentPosition currentVelocity = { x: x, y: currentPosition.y }
    where
        newX = currentPosition.x + floor currentVelocity.xSpeed
        x = if (newX + distance) < leftLimit.x 
            then leftLimit.x - distance
            else if (newX + distance) > rightLimit.x 
                then rightLimit.x - distance
                else newX

-- | Returns the left most `Position` of the two specified
ensureLeftLimit :: Position -> Position -> Position
ensureLeftLimit leftLimit rightLimit  = if leftLimit.x < rightLimit.x then leftLimit else rightLimit

-- | Returns the right most `Position` of the two specified
ensureRightLimit :: Position -> Position -> Position
ensureRightLimit leftLimit rightLimit  = if leftLimit.x > rightLimit.x then leftLimit else rightLimit

-- | De-increments the given value by 1 until it reaches zero. Then the value remains at zero.
coolDownShot :: Int -> Int
coolDownShot cooldown = if (cooldown - 1) < 0 then 0 else cooldown - 1