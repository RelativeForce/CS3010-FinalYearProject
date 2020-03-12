module Revoked.Data.Enemy.BigBertha.MachineGunPhase where

import Prelude

import Emo8.Types (Position, Velocity, Deg, X)
import Emo8.Utils (angle, vectorTo)

import Revoked.Constants (bigBerthaSpeed, bigBerthaMachineGunPhaseShotCooldown, bigBerthaMachineGunPhaseAccuracyDeviationIncrements, bigBerthaMachineGunPhaseMaxOffset)
import Revoked.Data.Bullet (Bullet, newLinearBullet, toBulletVelocity)
import Revoked.Data.Player (Player(..))
import Revoked.Data.Enemy.BigBertha.Helper (playerInRange, updateVelocity, updatePosition, ensureLeftLimit, ensureRightLimit, coolDownShot)

-- | Denotes the state of BigBertha that uses 
-- | the side mounted machine gun to attack the player.
type MachineGunPhase = { 
    pos :: Position,
    rightLimit :: Position,
    leftLimit :: Position,
    velocity :: Velocity,
    offset :: Int,
    shotCoolDown :: Int
}

-- | Whether the machine gun can fire this frame
canFire :: Player -> MachineGunPhase -> Boolean
canFire p machineGunPhase = machineGunPhase.shotCoolDown == 0 && playerInRange p machineGunPhase.pos

-- | The current angle deviation of the machine gun. Used to give the illusion of inaccuracy.
angleOffset :: Deg -> Int -> Deg
angleOffset angle offset = mod (angle + aOffset) 360
    where
        relativeOffset = offset - (bigBerthaMachineGunPhaseMaxOffset / 2)
        aOffset = bigBerthaMachineGunPhaseAccuracyDeviationIncrements * relativeOffset

-- | Retreives the angle to the player based on the position of BigBertha
angleToPlayer :: Player -> MachineGunPhase -> Deg
angleToPlayer (Player p) machineGunPhase = angle $ vectorTo (machineGunPosition machineGunPhase) p.pos

-- | The position that bullets should appear when fired from the machine gun.
machineGunPosition :: MachineGunPhase -> Position
machineGunPosition machineGunPhase = {
    x: machineGunPhase.pos.x + 78,
    y: machineGunPhase.pos.y + 27
}

-- | Builds a new bullet based on the players position, offset angle and Big bertha positon.
newBullet :: Player -> MachineGunPhase -> Bullet
newBullet p machineGunPhase = nb
    where
        angle = angleOffset (angleToPlayer p machineGunPhase) machineGunPhase.offset
        velocity = toBulletVelocity angle
        nb = newLinearBullet (machineGunPosition machineGunPhase) velocity

-- | Updates the machine gun phase of BigBertha based on the player's position. If the machine gun is
-- | fired the bullets are returned.
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

-- | Updates the position and velocity of big bertha using the cross-state logic defined in the BigBertha.Helper
updatePositionAndVelocity :: X -> MachineGunPhase -> MachineGunPhase
updatePositionAndVelocity distance machineGunPhase = machineGunPhase { pos = newPos, velocity = newVelocity }
    where
        newPos = updatePosition distance machineGunPhase.leftLimit machineGunPhase.rightLimit machineGunPhase.pos machineGunPhase.velocity
        newVelocity = updateVelocity distance machineGunPhase.leftLimit machineGunPhase.rightLimit machineGunPhase.pos machineGunPhase.velocity

-- | Builds the default machine gun phase
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