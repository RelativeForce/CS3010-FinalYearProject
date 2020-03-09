module Data.Enemy.BigBertha.Helper where

import Prelude
import Revoked.Constants (bigBerthaSpeed, bigBerthaAgroRange)
import Data.Player (Player(..))
import Data.Int (floor)
import Emo8.Types (Position, Velocity, X)
import Emo8.Utils (distanceBetween)

playerInRange :: Player -> Position -> Boolean
playerInRange (Player p) pos = bigBerthaAgroRange > distanceBetween p.pos pos

updateVelocity :: X -> Position -> Position -> Position -> Velocity -> Velocity
updateVelocity distance leftLimit rightLimit currentPosition currentVelocity = { xSpeed: xSpeed, ySpeed: 0.0 }
    where
        newX = currentPosition.x + floor currentVelocity.xSpeed
        xSpeed = if (newX + distance) < leftLimit.x 
            then 0.0 
            else if (newX + distance) > rightLimit.x 
                then -bigBerthaSpeed 
                else currentVelocity.xSpeed

updatePosition :: X -> Position -> Position -> Position -> Velocity -> Position
updatePosition distance leftLimit rightLimit currentPosition currentVelocity = { x: x, y: currentPosition.y }
    where
        newX = currentPosition.x + floor currentVelocity.xSpeed
        x = if (newX + distance) < leftLimit.x 
            then leftLimit.x - distance
            else if (newX + distance) > rightLimit.x 
                then rightLimit.x - distance
                else newX

ensureLeftLimit :: Position -> Position -> Position
ensureLeftLimit leftLimit rightLimit  = if leftLimit.x < rightLimit.x then leftLimit else rightLimit

ensureRightLimit :: Position -> Position -> Position
ensureRightLimit leftLimit rightLimit  = if leftLimit.x > rightLimit.x then leftLimit else rightLimit

coolDownShot :: Int -> Int
coolDownShot cooldown = if (cooldown - 1) < 0 then  0 else cooldown - 1