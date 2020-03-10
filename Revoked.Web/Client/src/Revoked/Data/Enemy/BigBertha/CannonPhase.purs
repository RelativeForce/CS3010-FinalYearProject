module Revoked.Data.Enemy.BigBertha.CannonPhase where

import Prelude

import Emo8.Types (Position, Velocity, Deg, X)

import Revoked.Constants (bigBerthaSpeed, bigBerthaCannonPhaseShotCooldown)
import Revoked.Data.Bullet (Bullet, newLinearBullet, toBulletVelocity)
import Revoked.Data.Player (Player)
import Revoked.Data.Enemy.BigBertha.Helper (playerInRange, updateVelocity, updatePosition, ensureLeftLimit, ensureRightLimit, coolDownShot)

-- | Denotes the state of BigBertha that uses 
-- | the main cannon to attack the player.
type CannonPhase = { 
    pos :: Position,
    rightLimit :: Position,
    leftLimit :: Position,
    velocity :: Velocity,
    shotCoolDown :: Int
}

-- | Whether the cannon can fire this frame
canFire :: Player -> CannonPhase -> Boolean
canFire p cannonPhase = cannonPhase.shotCoolDown == 0 && playerInRange p cannonPhase.pos

-- | The position that bullets should appear when fired from the cannon.
machineGunPosition :: CannonPhase -> Position
machineGunPosition cannonPhase = {
    x: cannonPhase.pos.x,
    y: cannonPhase.pos.y + 40
}

-- | Builds a new Bullet based on the given angle and the current position of big bertha
newBullet :: Deg -> CannonPhase -> Bullet
newBullet angle cannonPhase = nb
    where
        velocity = toBulletVelocity angle
        nb = newLinearBullet (machineGunPosition cannonPhase) velocity

-- | Updates the cannon phase of BigBertha based on the players position. If the cannon fires 
-- | the bullets are returned.
updateCannonPhase :: X -> Player -> CannonPhase -> { phase :: CannonPhase, bullets :: Array Bullet }
updateCannonPhase distance p cannonPhase = { phase: newCannonPhase, bullets: newBullets } 
    where
        -- Fire if the player is withing range and the shot has cooled down.
        shouldFire = canFire p cannonPhase
        newBullets = if shouldFire 
            then [ 
                newBullet 159 cannonPhase,
                newBullet 168 cannonPhase,
                newBullet 178 cannonPhase,
                newBullet 188 cannonPhase,
                newBullet 198 cannonPhase
            ] 
            else []
        -- Move Big Bertha
        movedCannonPhase = updatePositionAndVelocity distance cannonPhase
        newCannonPhase = movedCannonPhase {
            shotCoolDown = if shouldFire then bigBerthaCannonPhaseShotCooldown else coolDownShot movedCannonPhase.shotCoolDown
        }

-- | Updates the position and velocity of big bertha using the cross-state logic defined in the BigBertha.Helper
updatePositionAndVelocity :: X -> CannonPhase -> CannonPhase
updatePositionAndVelocity distance cannonPhase = cannonPhase { pos = newPos, velocity = newVelocity }
    where
        newPos = updatePosition distance cannonPhase.leftLimit cannonPhase.rightLimit cannonPhase.pos cannonPhase.velocity
        newVelocity = updateVelocity distance cannonPhase.leftLimit cannonPhase.rightLimit cannonPhase.pos cannonPhase.velocity

-- | Builds the default cannon phase
defaultCannonPhase :: Position -> Position -> Position -> CannonPhase
defaultCannonPhase pos leftLimit rightLimit = {
    pos: pos,
    leftLimit: ensureLeftLimit leftLimit rightLimit,
    rightLimit: ensureRightLimit leftLimit rightLimit,
    velocity: {
        xSpeed: -bigBerthaSpeed,
        ySpeed: 0.0
    },
    shotCoolDown: 0
}