module Revoked.Data.Enemy.Drone where

import Prelude

import Data.Array (length)
import Data.Int (floor)

import Emo8.Class.Object (size)
import Emo8.Data.Sprite (incrementFrame)
import Emo8.Types (Position, Sprite, Velocity, X, Deg)
import Emo8.Utils (vectorTo, angle)

import Revoked.Assets.Sprites as S
import Revoked.Data.Bullet (Bullet)
import Revoked.Data.Gun (Gun, defaultBlasterGun, fireAndUpdateGun, setPositionAndRotation)
import Revoked.Data.Player (Player(..))
import Revoked.Constants (droneAccuracyDeviationIncrements, droneSpeed)

-- | Denotes the state of a drone which fires 
-- | at the player with wild inaccuracy.
type Drone = { 
    pos :: Position,
    rightLimit :: Position,
    leftLimit :: Position,
    velocity :: Velocity,
    sprite :: Sprite,
    offset :: Int,
    gun :: Gun,
    health :: Int
}

-- | The max deviation increment from pefect accuracy.
maxOffset :: Int
maxOffset = 6

-- | The current angle deviation of the machine gun. Used to give the illusion of inaccuracy.
angleOffset :: Deg -> Int -> Deg
angleOffset angle offset = mod (angle + aOffset) 360
    where
        relativeOffset = offset - (maxOffset / 2)
        aOffset = droneAccuracyDeviationIncrements * relativeOffset

-- | Retreieves the angle from the specified drone to the specified player.
angleToPlayer :: Player -> Drone -> Deg
angleToPlayer (Player p) drone = angle $ vectorTo drone.pos p.pos

-- | Updates the given drone based on the player's position. If the drone is
-- | fired the bullets are returned.
updateDrone :: X -> Player -> Drone -> { enemy :: Drone, bullets :: Array Bullet }
updateDrone distance p drone = { enemy: newDrone, bullets: newBullets } 
    where
        { gun: potentialyFiredGun, bullets: newBullets } = fireAndUpdateGun drone.gun
        hasFired = (length newBullets) > 0
        newOffset = if hasFired then mod (drone.offset + 1) maxOffset else drone.offset
        updatedMotionDrone = updatePositionAndVelocity drone distance
        droneBasedOnVelocity = updatedMotionDrone {
            sprite = updateSprite drone updatedMotionDrone,
            offset = newOffset,
            gun = potentialyFiredGun
        }
        gunAngle = angleOffset (angleToPlayer p droneBasedOnVelocity) newOffset
        newDrone = adjustGunPosition droneBasedOnVelocity gunAngle

-- | Updtaes the given drone's sprite based on the change in direction.
updateSprite :: Drone -> Drone -> Sprite
updateSprite drone newDrone = newSprite
    where 
        sameDirection = newDrone.velocity.xSpeed == drone.velocity.xSpeed
        newSprite = if sameDirection 
            then incrementFrame drone.sprite 
            else if newDrone.velocity.xSpeed < 0.0 
                then S.droneLeft 
                else S.droneRight

-- | Adjusts the drones gun to be pointed at the specified angle at the 
-- | correct position relative to the drone.
adjustGunPosition :: Drone -> Deg -> Drone
adjustGunPosition m a = marinWithAdjustedGun
    where 
        gunSize = size m.gun
        gunPosX = m.pos.x + (m.sprite.size.width / 2)
        gunPosY = m.pos.y + 5
        gunPos = { x: gunPosX, y: gunPosY }
        marinWithAdjustedGun = m {
            gun = setPositionAndRotation m.gun gunPos a
        }

-- | Updates the drones velocity such that it moves lateraly between to positions. If the
-- | velocity would cause the drone to leave its limits then it is reversed. 
updateVelocity :: X -> Position -> Position -> Position -> Velocity -> Velocity
updateVelocity distance leftLimit rightLimit currentPosition currentVelocity = { xSpeed: xSpeed, ySpeed: ySpeed }
    where
        newX = currentPosition.x + floor currentVelocity.xSpeed
        newY = currentPosition.y + floor currentVelocity.ySpeed
        xSpeed = if (newX + distance) < leftLimit.x then droneSpeed else if (newX + distance) > rightLimit.x then -droneSpeed else currentVelocity.xSpeed
        ySpeed = if newY < leftLimit.y then droneSpeed else if newY > rightLimit.y then -droneSpeed else currentVelocity.ySpeed

-- | Applies the velocity of the drone's to the position such that it remains withing the specified limit positions.
updatePosition :: X -> Position -> Position -> Position -> Velocity -> Position
updatePosition distance leftLimit rightLimit currentPosition currentVelocity = { x: x, y: y }
    where
        newX = currentPosition.x + floor currentVelocity.xSpeed
        newY = currentPosition.y + floor currentVelocity.ySpeed
        x = if (newX + distance) < leftLimit.x then (leftLimit.x - distance) else if (newX + distance) > rightLimit.x then (rightLimit.x - distance) else newX
        y = if newY < leftLimit.y then leftLimit.y else if newY > rightLimit.y then rightLimit.y else newY

-- | Updates the drones velocity
updatePositionAndVelocity :: Drone -> X -> Drone
updatePositionAndVelocity drone distance = drone { pos = newPos, velocity = newVelocity }
    where
        newPos = updatePosition distance drone.leftLimit drone.rightLimit drone.pos drone.velocity
        newVelocity = updateVelocity distance drone.leftLimit drone.rightLimit drone.pos drone.velocity

-- | Returns the left most `Position` of the two specified
ensureLeftLimit :: Position -> Position -> Position
ensureLeftLimit leftLimit rightLimit  = if leftLimit.x < rightLimit.x then leftLimit else rightLimit

-- | Returns the right most `Position` of the two specified
ensureRightLimit :: Position -> Position -> Position
ensureRightLimit leftLimit rightLimit  = if leftLimit.x > rightLimit.x then leftLimit else rightLimit

-- | Builds the drone with a specified health and position limits
defaultDrone :: Int -> Position -> Position -> Drone
defaultDrone droneHealth leftLimit rightLimit = {
    pos: leftLimit,
    leftLimit: ensureLeftLimit leftLimit rightLimit,
    rightLimit: ensureRightLimit leftLimit rightLimit,
    sprite: S.droneRight,
    velocity: {
        xSpeed: droneSpeed,
        ySpeed: droneSpeed
    },
    offset: 0,
    gun: defaultBlasterGun leftLimit 270,
    health: droneHealth
}

