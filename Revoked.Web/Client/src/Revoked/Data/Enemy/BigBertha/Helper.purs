module Data.Enemy.BigBertha.Helper where

import Prelude
import Constants (bigBerthaSpeed, bigBerthaAgroRange)
import Data.Player (Player(..))
import Data.Int (floor)
import Emo8.Types (Position, Velocity)
import Emo8.Utils (distanceBetween)

playerInRange :: Player -> Position -> Boolean
playerInRange (Player p) pos = bigBerthaAgroRange > distanceBetween p.pos pos

updateVelocity :: Position -> Position -> Position -> Velocity -> Velocity
updateVelocity leftLimit rightLimit currentPosition currentVelocity = { xSpeed: xSpeed, ySpeed: 0.0 }
    where
        newX = currentPosition.x + floor currentVelocity.xSpeed
        xSpeed = if newX < leftLimit.x then 0.0 else if newX > rightLimit.x then -bigBerthaSpeed else currentVelocity.xSpeed

updatePosition :: Position -> Position -> Position -> Velocity -> Position
updatePosition leftLimit rightLimit currentPosition currentVelocity = { x: x, y: y }
    where
        newX = currentPosition.x + floor currentVelocity.xSpeed
        newY = currentPosition.y + floor currentVelocity.ySpeed
        x = if newX < leftLimit.x then leftLimit.x else if newX > rightLimit.x then rightLimit.x else newX
        y = if newY < leftLimit.y then leftLimit.y else if newY > rightLimit.y then rightLimit.y else newY

ensureLeftLimit :: Position -> Position -> Position
ensureLeftLimit leftLimit rightLimit  = if leftLimit.x < rightLimit.x then leftLimit else rightLimit

ensureRightLimit :: Position -> Position -> Position
ensureRightLimit leftLimit rightLimit  = if leftLimit.x > rightLimit.x then leftLimit else rightLimit

coolDownShot :: Int -> Int
coolDownShot cooldown = if (cooldown - 1) < 0 then  0 else cooldown - 1