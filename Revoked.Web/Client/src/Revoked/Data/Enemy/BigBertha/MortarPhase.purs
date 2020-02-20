module Data.Enemy.BigBertha.MortarPhase where

import Prelude

import Assets.Sprites as S
import Constants (gravity, mapTileSize)
import Data.Bullet (Bullet, newArcBullet)
import Data.Player (Player(..))
import Emo8.Data.Sprite (incrementFrame)
import Data.Int (floor, toNumber)
import Emo8.Types (Position, Sprite, Velocity)
import Math (sqrt, abs)
import Emo8.Utils (distanceBetween)

type MortarPhase = { 
    pos :: Position,
    rightLimit :: Position,
    leftLimit :: Position,
    velocity :: Velocity,
    sprite :: Sprite,
    shotCoolDown :: Int
}

mortarPhaseAgroRange :: Number
mortarPhaseAgroRange = 200.0

bigBerthaSpeed :: Number
bigBerthaSpeed = 1.0

mortarApex :: Number
mortarApex = toNumber $ mapTileSize.height * 12

horizontalVelocity :: Player -> MortarPhase -> Number
horizontalVelocity (Player p) mortarPhase = (d * sqrt g) / ((sqrt (2.0 * h)) + (sqrt (2.0 * l)))
    where
        d = abs $ toNumber $ mortarPhase.pos.x - p.pos.x
        h = mortarApex
        l = abs $ toNumber $ mortarPhase.pos.y - p.pos.y
        g = gravity

verticalVelocity :: Number
verticalVelocity = sqrt $ 2.0 * gravity * mortarApex

playerInRange :: Player -> MortarPhase -> Boolean
playerInRange (Player p) mortarPhase = mortarPhaseAgroRange > distanceBetween p.pos mortarPhase.pos

canFire :: Player -> MortarPhase -> Boolean
canFire p mortarPhase = mortarPhase.shotCoolDown == 0 && playerInRange p mortarPhase

bulletVelocity :: Player -> MortarPhase -> Velocity
bulletVelocity p mortarPhase = { xSpeed: xSpeed, ySpeed: ySpeed }
    where 
        xSpeed = - horizontalVelocity p mortarPhase
        ySpeed = verticalVelocity

updateMortarPhase :: Player -> MortarPhase -> { phase :: MortarPhase, bullets :: Array Bullet }
updateMortarPhase p mortarPhase = { phase: newMortarPhase, bullets: newBullets } 
    where
        shouldFire = canFire p mortarPhase
        newBullets = if shouldFire then [] else [ newArcBullet mortarPhase.pos (bulletVelocity p mortarPhase) ]
        movedMortarPhase = updatePositionAndVelocity mortarPhase
        newMortarPhase = movedMortarPhase {
            sprite = incrementFrame mortarPhase.sprite,
            shotCoolDown = if shouldFire then movedMortarPhase.shotCoolDown else 20
        }

updateVelocity :: Position -> Position -> Position -> Velocity -> Velocity
updateVelocity leftLimit rightLimit currentPosition currentVelocity = { xSpeed: xSpeed, ySpeed: ySpeed }
    where
        newX = currentPosition.x + floor currentVelocity.xSpeed
        newY = currentPosition.y + floor currentVelocity.ySpeed
        xSpeed = if newX < leftLimit.x then bigBerthaSpeed else if newX > rightLimit.x then -bigBerthaSpeed else currentVelocity.xSpeed
        ySpeed = if newY < leftLimit.y then bigBerthaSpeed else if newY > rightLimit.y then -bigBerthaSpeed else currentVelocity.ySpeed

updatePosition :: Position -> Position -> Position -> Velocity -> Position
updatePosition leftLimit rightLimit currentPosition currentVelocity = { x: x, y: y }
    where
        newX = currentPosition.x + floor currentVelocity.xSpeed
        newY = currentPosition.y + floor currentVelocity.ySpeed
        x = if newX < leftLimit.x then leftLimit.x else if newX > rightLimit.x then rightLimit.x else newX
        y = if newY < leftLimit.y then leftLimit.y else if newY > rightLimit.y then rightLimit.y else newY

updatePositionAndVelocity :: MortarPhase -> MortarPhase
updatePositionAndVelocity mortarPhase = mortarPhase { pos = newPos, velocity = newVelocity }
    where
        newPos = updatePosition mortarPhase.leftLimit mortarPhase.rightLimit mortarPhase.pos mortarPhase.velocity
        newVelocity = updateVelocity mortarPhase.leftLimit mortarPhase.rightLimit mortarPhase.pos mortarPhase.velocity

ensureLeftLimit :: Position -> Position -> Position
ensureLeftLimit leftLimit rightLimit  = if leftLimit.x < rightLimit.x then leftLimit else rightLimit

ensureRightLimit :: Position -> Position -> Position
ensureRightLimit leftLimit rightLimit  = if leftLimit.x > rightLimit.x then leftLimit else rightLimit

defaultMortarPhase :: Position -> Position -> MortarPhase
defaultMortarPhase leftLimit rightLimit = {
    pos: leftLimit,
    leftLimit: ensureLeftLimit leftLimit rightLimit,
    rightLimit: ensureRightLimit leftLimit rightLimit,
    sprite: S.droneRight,
    velocity: {
        xSpeed: bigBerthaSpeed,
        ySpeed: 0.0
    },
    shotCoolDown: 0
}