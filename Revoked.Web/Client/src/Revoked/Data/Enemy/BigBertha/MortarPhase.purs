module Data.Enemy.BigBertha.MortarPhase where

import Prelude

import Assets.Sprites as S
import Collision (adjustX)
import Constants (gravity)
import Class.Object (size)
import Data.Bullet (Bullet)
import Data.Gun (Gun, defaultPistolGun, fireAndUpdateGun, setPositionAndRotation, updateGun)
import Data.Player (Player(..))
import Emo8.Data.Sprite (incrementFrame)
import Data.Int (floor)
import Emo8.Types (Position, Sprite, Velocity, X, Deg)
import Emo8.Utils (updatePosition, distanceBetween, vectorTo, angle, xComponent, yComponent)

type MortarPhase = { 
    pos :: Position,
    rightLimit :: Position,
    leftLimit :: Position,
    velocity :: Velocity,
    sprite :: Sprite,
    shotCoolDown :: Int
}

mortarPhaseAgroRange :: Number
mortarPhaseAgroRange = 200

playerInRange :: Player -> MortarPhase -> Boolean
playerInRange (Player p) mortarPhase = mortarPhaseAgroRange > distanceBetween p.pos mortarPhase.pos




updateGunBasedOnRangeToPlayer :: Gun -> Boolean -> { gun :: Gun, bullets :: Array Bullet }
updateGunBasedOnRangeToPlayer g shouldFire = if shouldFire
    then fireAndUpdateGun g
    else { gun: updateGun g, bullets: [] }


updateMortarPhase :: (MortarPhase -> Boolean) -> X -> Player -> MortarPhase -> { enemy :: MortarPhase, bullets :: Array Bullet }
updateMortarPhase collisionCheck distance p mortarPhase = { enemy: newMortarPhase, bullets: newBullets } 
    where
        shouldFire = playerInRange p mortarPhase
        { gun: potentialyFiredGun, bullets: newBullets } = updateGunBasedOnRangeToPlayer mortarPhase.gun shouldFire
        newVelocityBasedOnGravity = updateVelocity mortarPhase.appear mortarPhase.velocity
        newPositionBasedOnVelocity = updatePosition mortarPhase.pos newVelocityBasedOnGravity
        mortarPhaseBasedOnVelocity = {
            pos: newPositionBasedOnVelocity,
            sprite: incrementFrame mortarPhase.sprite,
            appear: mortarPhase.appear,
            velocity: newVelocityBasedOnGravity,
            gun: potentialyFiredGun,
            health: mortarPhase.health
        }
        mortarPhaseBasedOnMapCollision = collideMortarPhase mortarPhase.pos mortarPhaseBasedOnVelocity distance collisionCheck
        mortarPhaseWithAdjustedVelocity = adjustVelocity mortarPhase.pos mortarPhaseBasedOnMapCollision
        gunAngle = angleToPlayer p mortarPhaseWithAdjustedVelocity
        newMortarPhase = adjustGunPosition mortarPhaseWithAdjustedVelocity gunAngle

adjustGunPosition :: MortarPhase -> Deg -> MortarPhase
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

updateVelocity :: MortarPhaseAppear -> Velocity -> Velocity
updateVelocity appear currentVelocity = { xSpeed: xSpeed, ySpeed: ySpeed }
    where
        xSpeed = velocityXBasedOnAppearance appear 
        ySpeed = currentVelocity.ySpeed + gravity

adjustVelocity :: Position -> MortarPhase -> MortarPhase
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

velocityXBasedOnAppearance :: MortarPhaseAppear -> Number
velocityXBasedOnAppearance appear = case appear of
    WalkingLeft -> -mortarPhaseWalkSpeed
    WalkingRight -> mortarPhaseWalkSpeed
    Standing -> 0.0 

reverseDirection :: MortarPhase -> MortarPhase
reverseDirection m = m {
    sprite = case newAppear of
        WalkingLeft -> S.mortarPhaseLeft
        WalkingRight ->  S.mortarPhaseRight
        Standing -> S.mortarPhaseStanding,
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

collideMortarPhase :: Position -> MortarPhase -> X -> (MortarPhase -> Boolean) -> MortarPhase
collideMortarPhase oldPos newMortarPhase distance collisionCheck = collidedMortarPhase { pos = collidedPos }
    where 
        newPos = newMortarPhase.pos
        size = newMortarPhase.sprite.size
        movingLeft = newPos.x < oldPos.x
        movingRight = newPos.x > oldPos.x
        xChangePlayer = newMortarPhase { 
            pos = { 
                x: newPos.x, 
                y: oldPos.y 
            }
        }
        yChangePlayerLeft = newMortarPhase { 
            pos = { 
                x: oldPos.x - size.width, 
                y: newPos.y 
            }
        }
        yChangePlayerRight = newMortarPhase { 
            pos = { 
                x: oldPos.x + size.width, 
                y: newPos.y 
            }
        }
        xCollide = collisionCheck xChangePlayer
        yCollideLeft = collisionCheck yChangePlayerLeft
        yCollideRight = collisionCheck yChangePlayerRight
        shouldReverse = xCollide || (movingLeft && not yCollideLeft) || (movingRight && not yCollideRight)
        collidedPos = if shouldReverse
            then { 
                x: adjustX oldPos.x newPos.x distance size.width, 
                y: oldPos.y 
            }
            else { 
                x: newPos.x, 
                y: oldPos.y 
            } 
        collidedMortarPhase = if shouldReverse 
            then (reverseDirection newMortarPhase) 
            else newMortarPhase

defaultMortarPhase :: Int -> Position -> MortarPhase
defaultMortarPhase mortarPhaseHealth pos = {
    pos: pos,
    sprite: S.mortarPhaseLeft,
    appear: WalkingLeft,
    velocity: {
        xSpeed: 0.0,
        ySpeed: 0.0
    },
    gun: defaultPistolGun true pos 180,
    health: mortarPhaseHealth
}