module Revoked.Data.Enemy.BigBertha.MortarPhase where

import Prelude

import Math (sqrt, abs)
import Data.Int (toNumber)

import Emo8.Types (Position, Velocity, X)

import Revoked.Constants (gravity, mapTileSize, bigBerthaSpeed, bigBerthaMortarPhaseShotCooldown)
import Revoked.Data.Bullet (Bullet, newArcBullet)
import Revoked.Data.Player (Player(..))
import Revoked.Data.Enemy.BigBertha.Helper (playerInRange, updateVelocity, updatePosition, ensureLeftLimit, ensureRightLimit, coolDownShot)

-- | Denotes the state of BigBertha that uses 
-- | the mortar to attack the player. 
type MortarPhase = { 
    pos :: Position,
    rightLimit :: Position,
    leftLimit :: Position,
    velocity :: Velocity,
    shotCoolDown :: Int
}
-- | The highest point from the mortar that a bullet will reach 
-- | when following a arcing trajectory.
mortarApex :: Number
mortarApex = toNumber $ mapTileSize.height * 12

-- | Calculates the horizontal velocity a projectile would need in order to follow a 
-- | arcing path such that it will intercept the target position when fired from 
-- | the mortar position.
-- | See github issue #103 for derivation of formula
horizontalVelocity :: Position -> Position -> Number
horizontalVelocity target mortar = (d * sqrt g) / ((sqrt (2.0 * h)) + sqrt (2.0 * (h - l)))
    where 
        d = toNumber $ target.x - mortar.x 
        h = mortarApex
        l = toNumber $ target.y - mortar.y
        g = abs gravity

-- | The vertical velocity required for a bullet to reach the apex
verticalVelocity :: Number
verticalVelocity = sqrt $ 2.0 * (abs gravity) * mortarApex

-- | Whether the mortar can fire this frame
canFire :: Player -> MortarPhase -> Boolean
canFire p mortarPhase = mortarPhase.shotCoolDown == 0 && playerInRange p mortarPhase.pos

-- | Determines a bullets velocity based on the players position and the mortar's position.
bulletVelocity :: Player -> MortarPhase -> Velocity
bulletVelocity (Player p) mortarPhase = { xSpeed: xSpeed, ySpeed: ySpeed }
    where 
        xSpeed = horizontalVelocity p.pos (mortarPosition mortarPhase)
        ySpeed = verticalVelocity

-- | The position that new bullets should appear when fired from the mortar.
mortarPosition :: MortarPhase -> Position
mortarPosition mortarPhase = {
    x: mortarPhase.pos.x + 110,
    y: mortarPhase.pos.y + 45
}

-- | Builds a new bullet based on the position of the player and the 
-- | position of the mortar.
newShell :: Player -> MortarPhase -> Bullet
newShell p mortarPhase = newArcBullet (mortarPosition mortarPhase) (bulletVelocity p mortarPhase)

-- | Updates the mortar phase of BigBertha based on the players position. If the cannon fires 
-- | the bullets are returned.
updateMortarPhase :: X -> Player -> MortarPhase -> { phase :: MortarPhase, bullets :: Array Bullet }
updateMortarPhase distance p mortarPhase = { phase: newMortarPhase, bullets: newBullets } 
    where
        shouldFire = canFire p mortarPhase
        newBullets = if shouldFire then [ newShell p mortarPhase ] else []
        movedMortarPhase = updatePositionAndVelocity distance mortarPhase
        newMortarPhase = movedMortarPhase {
            shotCoolDown = if shouldFire then bigBerthaMortarPhaseShotCooldown else coolDownShot movedMortarPhase.shotCoolDown
        }

-- | Updates the position and velocity of big bertha using the cross-state logic defined in the BigBertha.Helper
updatePositionAndVelocity :: X -> MortarPhase -> MortarPhase
updatePositionAndVelocity distance mortarPhase = mortarPhase { pos = newPos, velocity = newVelocity }
    where
        newPos = updatePosition distance mortarPhase.leftLimit mortarPhase.rightLimit mortarPhase.pos mortarPhase.velocity
        newVelocity = updateVelocity distance mortarPhase.leftLimit mortarPhase.rightLimit mortarPhase.pos mortarPhase.velocity

-- | Builds the default mortar phase
defaultMortarPhase :: Position -> Position -> Position -> MortarPhase
defaultMortarPhase pos leftLimit rightLimit = {
    pos: pos,
    leftLimit: ensureLeftLimit leftLimit rightLimit,
    rightLimit: ensureRightLimit leftLimit rightLimit,
    velocity: {
        xSpeed: -bigBerthaSpeed,
        ySpeed: 0.0
    },
    shotCoolDown: 0
}