module Data.Enemy.BigBertha.MachineGunPhase where

import Prelude

import Revoked.Constants (
    bigBerthaSpeed, 
    bigBerthaMachineGunPhaseShotCooldown, 
    bigBerthaMachineGunPhaseAccuracyDeviationIncrements, 
    bigBerthaMachineGunPhaseMaxOffset
)
import Data.Bullet (Bullet, newLinearBullet, toBulletVelocity)
import Data.Player (Player(..))
import Emo8.Types (Position, Velocity, Deg, X)
import Emo8.Utils (angle, vectorTo)
import Data.Enemy.BigBertha.Helper (
    playerInRange, 
    updateVelocity, 
    updatePosition, 
    ensureLeftLimit, 
    ensureRightLimit, 
    coolDownShot
)

type MachineGunPhase = { 
    pos :: Position,
    rightLimit :: Position,
    leftLimit :: Position,
    velocity :: Velocity,
    offset :: Int,
    shotCoolDown :: Int
}

canFire :: Player -> MachineGunPhase -> Boolean
canFire p machineGunPhase = machineGunPhase.shotCoolDown == 0 && playerInRange p machineGunPhase.pos

angleOffset :: Deg -> Int -> Deg
angleOffset angle offset = mod (angle + aOffset) 360
    where
        relativeOffset = offset - (bigBerthaMachineGunPhaseMaxOffset / 2)
        aOffset = bigBerthaMachineGunPhaseAccuracyDeviationIncrements * relativeOffset

angleToPlayer :: Player -> MachineGunPhase -> Deg
angleToPlayer (Player p) machineGunPhase = angle $ vectorTo (machineGunPosition machineGunPhase) p.pos

machineGunPosition :: MachineGunPhase -> Position
machineGunPosition machineGunPhase = {
    x: machineGunPhase.pos.x + 78,
    y: machineGunPhase.pos.y + 27
}

newBullet :: Player -> MachineGunPhase -> Bullet
newBullet p machineGunPhase = nb
    where
        angle = angleOffset (angleToPlayer p machineGunPhase) machineGunPhase.offset
        velocity = toBulletVelocity angle
        nb = newLinearBullet (machineGunPosition machineGunPhase) velocity

updateMachineGunPhase :: X -> Player -> MachineGunPhase -> { phase :: MachineGunPhase, bullets :: Array Bullet }
updateMachineGunPhase distance p machineGunPhase = { phase: newMachineGunPhase, bullets: newBullets } 
    where
        shouldFire = canFire p machineGunPhase
        newBullets = if shouldFire then [ newBullet p machineGunPhase ] else []
        movedMachineGunPhase = updatePositionAndVelocity distance machineGunPhase
        newOffset = if shouldFire then mod (machineGunPhase.offset + 1) bigBerthaMachineGunPhaseMaxOffset else machineGunPhase.offset
        newMachineGunPhase = movedMachineGunPhase {
            offset = newOffset,
            shotCoolDown = if shouldFire then bigBerthaMachineGunPhaseShotCooldown else coolDownShot movedMachineGunPhase.shotCoolDown
        }

updatePositionAndVelocity :: X -> MachineGunPhase -> MachineGunPhase
updatePositionAndVelocity distance machineGunPhase = machineGunPhase { pos = newPos, velocity = newVelocity }
    where
        newPos = updatePosition distance machineGunPhase.leftLimit machineGunPhase.rightLimit machineGunPhase.pos machineGunPhase.velocity
        newVelocity = updateVelocity distance machineGunPhase.leftLimit machineGunPhase.rightLimit machineGunPhase.pos machineGunPhase.velocity

defaultMachineGunPhase :: Position -> Position -> Position -> MachineGunPhase
defaultMachineGunPhase pos leftLimit rightLimit = {
    pos: pos,
    leftLimit: ensureLeftLimit leftLimit rightLimit,
    rightLimit: ensureRightLimit leftLimit rightLimit,
    offset: 0,
    velocity: {
        xSpeed: -bigBerthaSpeed,
        ySpeed: 0.0
    },
    shotCoolDown: 0
}