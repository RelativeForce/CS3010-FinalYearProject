module Revoked.Data.Enemy.Marine where

import Prelude

import Data.Int (floor)

import Emo8.Class.Object (size)
import Emo8.Types (Position, Sprite, Velocity, X, Deg)
import Emo8.Utils (updatePosition, distanceBetween, vectorTo, angle, xComponent, yComponent)
import Emo8.Data.Sprite (incrementFrame)

import Revoked.Assets.Sprites as S
import Revoked.Collision (adjustX)
import Revoked.Constants (marineWalkSpeed, gravity, marineAgroRange)
import Revoked.Data.Bullet (Bullet)
import Revoked.Data.Gun (Gun, defaultPistolGun, fireAndUpdateGun, setPositionAndRotation, updateGun)
import Revoked.Data.Player (Player(..))

-- | Represents the directions a marine can face.
data MarineAppear = Standing | WalkingLeft | WalkingRight 

-- | Represents the state of the Marine enemy which will 
-- | shoot a Player when within range.
type Marine = { 
    pos :: Position,
    velocity :: Velocity,
    sprite :: Sprite,
    appear :: MarineAppear,
    gun :: Gun,
    health :: Int
}

-- | Updates the Marine's gun and fires it if specified.
updateGunBasedOnRangeToPlayer :: Gun -> Boolean -> { gun :: Gun, bullets :: Array Bullet }
updateGunBasedOnRangeToPlayer g shouldFire = if shouldFire
    then fireAndUpdateGun g
    else { gun: updateGun g, bullets: [] }

-- | Whether or not the player is within range of the Marine and thus start firing.
playerInRange :: Player -> Marine -> Boolean
playerInRange (Player p) marine = marineAgroRange > distanceBetween p.pos marine.pos

-- | Retrieves the angle to the player from the Marines position.
angleToPlayer :: Player -> Marine -> Deg
angleToPlayer (Player p) marine = angle $ vectorTo marine.pos p.pos

-- | Updates the position of a given marine based on the position of the player and its collision with the 
-- | map. The collision is given by the collision check function.
updateMarine :: (Marine -> Boolean) -> X -> Player -> Marine -> { enemy :: Marine, bullets :: Array Bullet }
updateMarine collisionCheck distance p marine = { enemy: newMarine, bullets: newBullets } 
    where
        shouldFire = playerInRange p marine
        { gun: potentialyFiredGun, bullets: newBullets } = updateGunBasedOnRangeToPlayer marine.gun shouldFire
        newVelocityBasedOnGravity = updateVelocity marine.appear marine.velocity
        newPositionBasedOnVelocity = updatePosition marine.pos newVelocityBasedOnGravity
        marineBasedOnVelocity = {
            pos: newPositionBasedOnVelocity,
            sprite: incrementFrame marine.sprite,
            appear: marine.appear,
            velocity: newVelocityBasedOnGravity,
            gun: potentialyFiredGun,
            health: marine.health
        }
        marineBasedOnMapCollision = collideMarine marine.pos marineBasedOnVelocity distance collisionCheck
        marineWithAdjustedVelocity = adjustVelocity marine.pos marineBasedOnMapCollision
        gunAngle = angleToPlayer p marineWithAdjustedVelocity
        newMarine = adjustGunPosition marineWithAdjustedVelocity gunAngle

-- | Adjusts the position of the Marines gun such that it is pointing in the specfied direction 
-- | and is in the correct position.
adjustGunPosition :: Marine -> Deg -> Marine
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

-- | Updates the valeocity of a Marine based on the direction it is facing and gravity.
updateVelocity :: MarineAppear -> Velocity -> Velocity
updateVelocity appear currentVelocity = { xSpeed: xSpeed, ySpeed: ySpeed }
    where
        xSpeed = velocityXBasedOnAppearance appear 
        ySpeed = currentVelocity.ySpeed + gravity

-- | Adjusts a marines velocity based on its change in position. If it hasnt moved in a given 
-- | direction set that directions velocity component to zero.
adjustVelocity :: Position -> Marine -> Marine
adjustVelocity oldPos new = new { 
    velocity = {
        xSpeed: xSpeed,
        ySpeed: ySpeed
    }   
} 
    where
        currentVelocity = new.velocity
        newPos = new.pos
        xSpeed = if oldPos.x == newPos.x
            then 0.0
            else currentVelocity.xSpeed
        ySpeed = if oldPos.y == newPos.y
            then 0.0
            else currentVelocity.ySpeed

-- | Retrieves the velocity that a marin should have based on 
-- | the direction is it facing.
velocityXBasedOnAppearance :: MarineAppear -> Number
velocityXBasedOnAppearance appear = case appear of
    WalkingLeft -> -marineWalkSpeed
    WalkingRight -> marineWalkSpeed
    Standing -> 0.0 

-- | Reverses the marines horizontal velocity and sprite
reverseDirection :: Marine -> Marine
reverseDirection m = m {
    sprite = case newAppear of
        WalkingLeft -> S.marineLeft
        WalkingRight ->  S.marineRight
        Standing -> S.marineStanding,
    appear = newAppear,
    velocity = {
        xSpeed: velocityXBasedOnAppearance newAppear,
        ySpeed: m.velocity.ySpeed
    }
}
    where 
        newAppear = case m.appear of
            WalkingLeft -> WalkingRight
            WalkingRight -> WalkingLeft
            Standing -> Standing

-- | Adjusts the position and direction of movement of a marine based on its collision with the 
-- | map. This collision is defined by the collision check function given.
collideMarine :: Position -> Marine -> X -> (Marine -> Boolean) -> Marine
collideMarine oldPos newMarine distance collisionCheck = collidedMarine { pos = collidedPos }
    where 
        newPos = newMarine.pos
        size = newMarine.sprite.size
        movingLeft = newPos.x < oldPos.x
        movingRight = newPos.x > oldPos.x

        -- Moved in x
        xChange = newMarine { 
            pos = { 
                x: newPos.x, 
                y: oldPos.y 
            }
        }

        -- Applied gravity and moved the width to the left
        yChangeLeft = newMarine { 
            pos = { 
                x: oldPos.x - size.width, 
                y: newPos.y 
            }
        }

        -- Applied gravity and moved the width to the right
        yChangeRight = newMarine { 
            pos = { 
                x: oldPos.x + size.width, 
                y: newPos.y 
            }
        }

        -- Collision checks
        xCollide = collisionCheck xChange
        yCollideLeft = collisionCheck yChangeLeft
        yCollideRight = collisionCheck yChangeRight

        -- If the marine has collided horizontally then it should reverse direction. It should also reverse if moving 
        -- along its current path would cause it to step off a cliff.
        shouldReverse = xCollide || (movingLeft && not yCollideLeft) || (movingRight && not yCollideRight)

        -- Update position
        collidedPos = if shouldReverse
            then { 
                x: adjustX oldPos.x newPos.x distance size.width, 
                y: oldPos.y 
            }
            else { 
                x: newPos.x, 
                y: oldPos.y 
            } 
        
        -- Update marine
        collidedMarine = if shouldReverse 
            then (reverseDirection newMarine) 
            else newMarine

-- | Builds a default marine with a specifed initial health and `Position`. 
defaultMarine :: Int -> Position -> Marine
defaultMarine marineHealth pos = {
    pos: pos,
    sprite: S.marineLeft,
    appear: WalkingLeft,
    velocity: {
        xSpeed: 0.0,
        ySpeed: 0.0
    },
    gun: defaultPistolGun pos 180,
    health: marineHealth
}