module Data.Enemy.BigBertha.CannonPhase where

import Prelude

import Constants (bulletSpeed, bigBerthaSpeed)
import Data.Bullet (Bullet, newLinearBullet)
import Data.Player (Player(..))
import Emo8.Types (Position, Velocity, Deg, X)
import Emo8.Utils (xComponent, yComponent, angle, vectorTo)
import Data.Enemy.BigBertha.Helper (playerInRange, updateVelocity, updatePosition, ensureLeftLimit, ensureRightLimit, coolDownShot)

type CannonPhase = { 
    pos :: Position,
    rightLimit :: Position,
    leftLimit :: Position,
    velocity :: Velocity,
    offset :: Int,
    shotCoolDown :: Int
}

accuracyDeviationIncrements :: Int
accuracyDeviationIncrements = 5

maxOffset :: Int
maxOffset = 7

shotCooldown :: Int
shotCooldown = 20

bulletVelocity :: Deg -> Velocity
bulletVelocity angle = velocity
    where
        velocity = {
            xSpeed: xComponent angle bulletSpeed,
            ySpeed: yComponent angle bulletSpeed
        }

canFire :: Player -> CannonPhase -> Boolean
canFire p cannonPhase = cannonPhase.shotCoolDown == 0 && playerInRange p cannonPhase.pos

angleOffset :: Deg -> Int -> Deg
angleOffset angle offset = mod (angle + aOffset) 360
    where
        relativeOffset = offset - (maxOffset / 2)
        aOffset = accuracyDeviationIncrements * relativeOffset

angleToPlayer :: Player -> CannonPhase -> Deg
angleToPlayer (Player p) cannonPhase = angle $ vectorTo (machineGunPosition cannonPhase) p.pos

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
        newOffset = if shouldFire then mod (cannonPhase.offset + 1) maxOffset else cannonPhase.offset
        newCannonPhase = movedCannonPhase {
            offset = newOffset,
            shotCoolDown = if shouldFire then shotCooldown else coolDownShot movedCannonPhase.shotCoolDown
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
    offset: 0,
    velocity: {
        xSpeed: -bigBerthaSpeed,
        ySpeed: 0.0
    },
    shotCoolDown: 0
}