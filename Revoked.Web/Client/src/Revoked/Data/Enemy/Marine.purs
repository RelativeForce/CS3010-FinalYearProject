module Data.Enemy.Marine where

import Prelude

import Assets.Sprites as S
import Collision (adjustX)
import Constants (marineWalkSpeed, gravity, marineAgroRange)
import Data.Bullet (Bullet)
import Data.Gun (Gun, defaultPistolGun, fireAndUpdateGun, setPositionAndRotation, updateGun)
import Data.Player (Player(..))
import Emo8.Data.Sprite (incrementFrame)
import Emo8.Types (Position, Sprite, Velocity, X, Deg)
import Emo8.Utils (updatePosition, distanceBetween, vectorTo, angle)

data MarineAppear = Standing | WalkingLeft | WalkingRight 

type Marine = { 
    pos :: Position,
    velocity :: Velocity,
    sprite :: Sprite,
    appear :: MarineAppear,
    gun :: Gun
}

updateGunBasedOnRangeToPlayer :: Gun -> Boolean -> { gun :: Gun, bullets :: Array Bullet }
updateGunBasedOnRangeToPlayer g shouldFire = if shouldFire
    then fireAndUpdateGun g
    else { gun: updateGun g, bullets: [] }

playerInRange :: Player -> Marine -> Boolean
playerInRange (Player p) marine = marineAgroRange > distanceBetween p.pos marine.pos

angleToPlayer :: Player -> Marine -> Deg
angleToPlayer (Player p) marine = angle $ vectorTo p.pos marine.pos

updateMarine :: (Marine -> Boolean) -> X -> Player -> Marine -> { enemy :: Marine, bullets :: Array Bullet }
updateMarine collisionCheck distance p marine = { enemy: newMarine, bullets: newBullets } 
    where

        { gun: potentialyFiredGun, bullets: newBullets } = updateGunBasedOnRangeToPlayer marine.gun (playerInRange p marine)
        newVelocityBasedOnGravity = updateVelocity marine.appear marine.velocity
        newPositionBasedOnVelocity = updatePosition marine.pos newVelocityBasedOnGravity
        marineBasedOnVelocity = {
            pos: newPositionBasedOnVelocity,
            sprite: incrementFrame marine.sprite,
            appear: marine.appear,
            velocity: newVelocityBasedOnGravity,
            gun: potentialyFiredGun
        }
        marineBasedOnMapCollision = collideMarine marine.pos marineBasedOnVelocity distance collisionCheck
        marineWithAdjustedVelocity = adjustVelocity marine.pos marineBasedOnMapCollision
        newMarine = adjustGunPosition marineWithAdjustedVelocity (angleToPlayer p marineWithAdjustedVelocity)

adjustGunPosition :: Marine -> Deg -> Marine
adjustGunPosition m a = marinWithAdjustedGun
    where 
        gunPosX = case m.appear of
            WalkingLeft -> m.pos.x - 12
            WalkingRight -> m.pos.x + m.sprite.size.width - 5
            Standing -> m.pos.x + m.sprite.size.width - 5
        gunPosY = m.pos.y + (m.sprite.size.height / 2) - 3
        gunPos = { x: gunPosX, y: gunPosY }
        marinWithAdjustedGun = m {
            gun = setPositionAndRotation m.gun gunPos a
        }

updateVelocity :: MarineAppear -> Velocity -> Velocity
updateVelocity appear currentVelocity = { xSpeed: xSpeed, ySpeed: ySpeed }
    where
        xSpeed = velocityXBasedOnAppearance appear 
        ySpeed = currentVelocity.ySpeed + gravity

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

velocityXBasedOnAppearance :: MarineAppear -> Number
velocityXBasedOnAppearance appear = case appear of
    WalkingLeft -> -marineWalkSpeed
    WalkingRight -> marineWalkSpeed
    Standing -> 0.0 

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

collideMarine :: Position -> Marine -> X -> (Marine -> Boolean) -> Marine
collideMarine oldPos newMarine distance collisionCheck = collidedMarine { pos = collidedPos }
    where 
        newPos = newMarine.pos
        size = newMarine.sprite.size
        movingLeft = newPos.x < oldPos.x
        movingRight = newPos.x > oldPos.x
        xChangePlayer = newMarine { 
            pos = { 
                x: newPos.x, 
                y: oldPos.y 
            }
        }
        yChangePlayerLeft = newMarine { 
            pos = { 
                x: oldPos.x - size.width, 
                y: newPos.y 
            }
        }
        yChangePlayerRight = newMarine { 
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
        collidedMarine = if shouldReverse 
            then (reverseDirection newMarine) 
            else newMarine

defaultMarine :: Position -> Marine
defaultMarine pos = {
    pos: pos,
    sprite: S.marineLeft,
    appear: WalkingLeft,
    velocity: {
        xSpeed: 0.0,
        ySpeed: 0.0
    },
    gun: defaultPistolGun true pos 90
}