module Data.Enemy.BigBertha.MortarPhase where

import Prelude

import Constants (gravity, mapTileSize, bigBerthaSpeed)
import Data.Bullet (Bullet, newArcBullet)
import Data.Player (Player(..))
import Data.Int (toNumber)
import Emo8.Types (Position, Sprite, Velocity, X)
import Math (sqrt, abs)
import Data.Enemy.BigBertha.Helper (playerInRange, updateVelocity, updatePosition, ensureLeftLimit, ensureRightLimit, coolDownShot)

type MortarPhase = { 
    pos :: Position,
    rightLimit :: Position,
    leftLimit :: Position,
    velocity :: Velocity,
    shotCoolDown :: Int
}

mortarApex :: Number
mortarApex = toNumber $ mapTileSize.height * 12

shotCooldown :: Int
shotCooldown = 10

horizontalVelocity :: Player -> MortarPhase -> Number
horizontalVelocity (Player p) mortarPhase = (d * g) / ((2.0 * g * sqrt (2.0 * h)) - sqrt (h + l))
    where
        mortarPos = mortarPosition mortarPhase
        d = abs $ toNumber $ mortarPos.x - p.pos.x
        h = mortarApex
        l = toNumber $ p.pos.y - mortarPos.y
        g = gravity

verticalVelocity :: Number
verticalVelocity = sqrt $ 2.0 * (abs gravity) * mortarApex

canFire :: Player -> MortarPhase -> Boolean
canFire p mortarPhase = mortarPhase.shotCoolDown == 0 && playerInRange p mortarPhase.pos

bulletVelocity :: Player -> MortarPhase -> Velocity
bulletVelocity p mortarPhase = { xSpeed: xSpeed, ySpeed: ySpeed }
    where 
        xSpeed = - horizontalVelocity p mortarPhase
        ySpeed = verticalVelocity

mortarPosition :: MortarPhase -> Position
mortarPosition mortarPhase = {
    x: mortarPhase.pos.x + 110,
    y: mortarPhase.pos.y + 45
}

newShell :: Player -> MortarPhase -> Bullet
newShell p mortarPhase = newArcBullet (mortarPosition mortarPhase) (bulletVelocity p mortarPhase)

updateMortarPhase :: X -> Player -> MortarPhase -> { phase :: MortarPhase, bullets :: Array Bullet }
updateMortarPhase distance p mortarPhase = { phase: newMortarPhase, bullets: newBullets } 
    where
        shouldFire = canFire p mortarPhase
        newBullets = if shouldFire then [ newShell p mortarPhase ] else []
        movedMortarPhase = updatePositionAndVelocity distance mortarPhase
        newMortarPhase = movedMortarPhase {
            shotCoolDown = if shouldFire then shotCooldown else coolDownShot movedMortarPhase.shotCoolDown
        }

updatePositionAndVelocity :: X -> MortarPhase -> MortarPhase
updatePositionAndVelocity distance mortarPhase = mortarPhase { pos = newPos, velocity = newVelocity }
    where
        newPos = updatePosition distance mortarPhase.leftLimit mortarPhase.rightLimit mortarPhase.pos mortarPhase.velocity
        newVelocity = updateVelocity distance mortarPhase.leftLimit mortarPhase.rightLimit mortarPhase.pos mortarPhase.velocity

defaultMortarPhase :: Position -> Position -> Position -> MortarPhase
defaultMortarPhase pos leftLimit rightLimit = {
    pos: pos,
    leftLimit: ensureLeftLimit leftLimit rightLimit,
    rightLimit: ensureRightLimit leftLimit rightLimit,
    velocity: {
        xSpeed: bigBerthaSpeed,
        ySpeed: 0.0
    },
    shotCoolDown: 0
}