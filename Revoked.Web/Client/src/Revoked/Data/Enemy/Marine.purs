module Data.Enemy.Marine where

import Prelude

import Constants (marineWalkSpeed, gravity)
import Assets.Sprites as S
import Emo8.Types (Position, Sprite, Velocity, X)
import Data.Player (Player(..))
import Collision (adjustX)
import Emo8.Utils (updatePosition)
import Emo8.Data.Sprite (incrementFrame)

data MarineAppear = Standing | WalkingLeft | WalkingRight 

type Marine = { 
    pos :: Position,
    velocity :: Velocity,
    sprite :: Sprite,
    appear :: MarineAppear,
    shotCoolDown :: Int
}

updateMarine :: (Marine -> Boolean) -> X -> Player -> Marine -> Marine
updateMarine collisionCheck distance playerObject marine = newMarine
    where
        newVelocityBasedOnGravity = updateVelocity marine.appear marine.velocity
        newPositionBasedOnVelocity = updatePosition marine.pos newVelocityBasedOnGravity
        shotCoolDown = if marine.shotCoolDown > 0 then marine.shotCoolDown - 1 else 0
        marineBasedOnVelocity = {
            pos: newPositionBasedOnVelocity,
            sprite: incrementFrame marine.sprite,
            appear: marine.appear,
            velocity: newVelocityBasedOnGravity,
            shotCoolDown: marine.shotCoolDown
        }
        marineBasedOnMapCollision = collideMarine marine.pos marineBasedOnVelocity distance collisionCheck
        newMarine = adjustVelocity marine.pos marineBasedOnMapCollision

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
                x: adjustX oldPos.x newPos.x distance, 
                y: oldPos.y 
            }
            else { 
                x: newPos.x, 
                y: oldPos.y 
            } 
        collidedMarine = if shouldReverse 
            then (reverseDirection newMarine) 
            else newMarine