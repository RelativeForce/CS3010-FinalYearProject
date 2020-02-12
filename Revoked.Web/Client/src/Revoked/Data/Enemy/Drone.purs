module Data.Enemy.Drone where

import Prelude

import Assets.Sprites as S
import Class.Object (size)
import Data.Bullet (Bullet)
import Data.Gun (Gun, defaultBlasterGun, fireAndUpdateGun, setPositionAndRotation)
import Data.Player (Player(..))
import Emo8.Data.Sprite (incrementFrame)
import Data.Array (length)
import Data.Int (floor)
import Emo8.Types (Position, Sprite, Velocity, X, Deg)
import Emo8.Utils (vectorTo, angle, xComponent, yComponent)

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

angleIncrement :: Int
angleIncrement = 10

maxOffset :: Int
maxOffset = 6

maxMovementSpeed :: Number
maxMovementSpeed = 1.0

angleOffset :: Deg -> Int -> Deg
angleOffset angle offset = mod (angle + aOffset) 360
    where
        relativeOffset = offset - (maxOffset / 2)
        aOffset = angleIncrement * relativeOffset

angleToPlayer :: Player -> Drone -> Deg
angleToPlayer (Player p) drone = angle $ vectorTo drone.pos p.pos

updateDrone :: X -> Player -> Drone -> { enemy :: Drone, bullets :: Array Bullet }
updateDrone distance p drone = { enemy: newDrone, bullets: newBullets } 
    where
        { gun: potentialyFiredGun, bullets: newBullets } = fireAndUpdateGun drone.gun
        hasFired = (length newBullets) > 0
        newOffset = if hasFired then mod (drone.offset + 1) maxOffset else drone.offset
        updatedMotionDrone = updatePositionAndVelocity drone
        droneBasedOnVelocity = updatedMotionDrone {
            sprite = updateSprite drone updatedMotionDrone,
            offset = newOffset,
            gun = potentialyFiredGun
        }
        gunAngle = angleOffset (angleToPlayer p droneBasedOnVelocity) newOffset
        newDrone = adjustGunPosition droneBasedOnVelocity gunAngle

updateSprite :: Drone -> Drone -> Sprite
updateSprite drone newDrone = newSprite
    where 
        sameDirection = newDrone.velocity.xSpeed == drone.velocity.xSpeed
        newSprite = if sameDirection 
            then incrementFrame drone.sprite 
            else if newDrone.velocity.xSpeed < 0.0 
                then S.droneLeft 
                else S.droneRight

adjustGunPosition :: Drone -> Deg -> Drone
adjustGunPosition m a = marinWithAdjustedGun
    where 
        radius = 10.0
        gunSize = size m.gun
        gunPosX = m.pos.x + (m.sprite.size.width / 2) + floor (xComponent a radius)
        gunPosY = m.pos.y + (m.sprite.size.height / 2) - gunSize.height - (floor ((yComponent a radius) / 2.0))
        gunPos = { x: gunPosX, y: gunPosY }
        marinWithAdjustedGun = m {
            gun = setPositionAndRotation m.gun gunPos a
        }

updateVelocity :: Position -> Position -> Position -> Velocity -> Velocity
updateVelocity leftLimit rightLimit currentPosition currentVelocity = { xSpeed: xSpeed, ySpeed: ySpeed }
    where
        newX = currentPosition.x + floor currentVelocity.xSpeed
        newY = currentPosition.y + floor currentVelocity.ySpeed
        xSpeed = if newX < leftLimit.x then maxMovementSpeed else if newX > rightLimit.x then -maxMovementSpeed else currentVelocity.xSpeed
        ySpeed = if newY < leftLimit.y then maxMovementSpeed else if newY > rightLimit.y then -maxMovementSpeed else currentVelocity.ySpeed

updatePosition :: Position -> Position -> Position -> Velocity -> Position
updatePosition leftLimit rightLimit currentPosition currentVelocity = { x: x, y: y }
    where
        newX = currentPosition.x + floor currentVelocity.xSpeed
        newY = currentPosition.y + floor currentVelocity.ySpeed
        x = if newX < leftLimit.x then leftLimit.x else if newX > rightLimit.x then rightLimit.x else newX
        y = if newY < leftLimit.y then leftLimit.y else if newY > rightLimit.y then rightLimit.y else newY

updatePositionAndVelocity :: Drone -> Drone
updatePositionAndVelocity drone = drone { pos = newPos, velocity = newVelocity }
    where
        newPos = updatePosition drone.leftLimit drone.rightLimit drone.pos drone.velocity
        newVelocity = updateVelocity drone.leftLimit drone.rightLimit drone.pos drone.velocity

ensureLeftLimit :: Position -> Position -> Position
ensureLeftLimit leftLimit rightLimit  = if leftLimit.x < rightLimit.x then leftLimit else rightLimit

ensureRightLimit :: Position -> Position -> Position
ensureRightLimit leftLimit rightLimit  = if leftLimit.x > rightLimit.x then leftLimit else rightLimit

defaultDrone :: Int -> Position -> Position -> Drone
defaultDrone droneHealth leftLimit rightLimit = {
    pos: leftLimit,
    leftLimit: ensureLeftLimit leftLimit rightLimit,
    rightLimit: ensureRightLimit leftLimit rightLimit,
    sprite: S.droneRight,
    velocity: {
        xSpeed: maxMovementSpeed,
        ySpeed: maxMovementSpeed
    },
    offset: 0,
    gun: defaultBlasterGun leftLimit 270,
    health: 1
}

