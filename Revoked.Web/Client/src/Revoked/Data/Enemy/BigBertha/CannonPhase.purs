module Data.Enemy.BigBertha.CannonPhase where

import Prelude

import Constants (bulletSpeed, bigBerthaSpeed, bigBerthaCannonPhaseShotCooldown)
import Data.Bullet (Bullet, newLinearBullet)
import Data.Player (Player)
import Emo8.Types (Position, Velocity, Deg, X)
import Emo8.Utils (xComponent, yComponent)
import Data.Enemy.BigBertha.Helper (playerInRange, updateVelocity, updatePosition, ensureLeftLimit, ensureRightLimit, coolDownShot)

type CannonPhase = { 
    pos :: Position,
    rightLimit :: Position,
    leftLimit :: Position,
    velocity :: Velocity,
    shotCoolDown :: Int
}

bulletVelocity :: Deg -> Velocity
bulletVelocity angle = velocity
    where
        velocity = {
            xSpeed: xComponent angle bulletSpeed,
            ySpeed: yComponent angle bulletSpeed
        }

canFire :: Player -> CannonPhase -> Boolean
canFire p cannonPhase = cannonPhase.shotCoolDown == 0 && playerInRange p cannonPhase.pos

machineGunPosition :: CannonPhase -> Position
machineGunPosition cannonPhase = {
    x: cannonPhase.pos.x,
    y: cannonPhase.pos.y + 40
}

newBullet :: Deg -> CannonPhase -> Bullet
newBullet angle cannonPhase = nb
    where
        velocity = bulletVelocity angle
        nb = newLinearBullet (machineGunPosition cannonPhase) velocity

updateCannonPhase :: X -> Player -> CannonPhase -> { phase :: CannonPhase, bullets :: Array Bullet }
updateCannonPhase distance p cannonPhase = { phase: newCannonPhase, bullets: newBullets } 
    where
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
        movedCannonPhase = updatePositionAndVelocity distance cannonPhase
        newCannonPhase = movedCannonPhase {
            shotCoolDown = if shouldFire then bigBerthaCannonPhaseShotCooldown else coolDownShot movedCannonPhase.shotCoolDown
        }

updatePositionAndVelocity :: X -> CannonPhase -> CannonPhase
updatePositionAndVelocity distance cannonPhase = cannonPhase { pos = newPos, velocity = newVelocity }
    where
        newPos = updatePosition distance cannonPhase.leftLimit cannonPhase.rightLimit cannonPhase.pos cannonPhase.velocity
        newVelocity = updateVelocity distance cannonPhase.leftLimit cannonPhase.rightLimit cannonPhase.pos cannonPhase.velocity

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