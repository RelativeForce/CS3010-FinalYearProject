module Data.Enemy.Marine where

import Prelude

import Constants (marineWalkSpeed, gravity, marineAgroRange, marineShotCooldown, marineBulletSpeed)
import Assets.Sprites as S
import Emo8.Types (Position, Sprite, Velocity, X)
import Data.EnemyBullet (EnemyBullet(..))
import Data.Player (Player(..))
import Collision (adjustX)
import Emo8.Utils (updatePosition, distanceBetween, vectorTo, toVelocity, normalise)
import Emo8.Data.Sprite (incrementFrame)

data MarineAppear = Standing | WalkingLeft | WalkingRight 

type Marine = { 
    pos :: Position,
    velocity :: Velocity,
    sprite :: Sprite,
    appear :: MarineAppear,
    shotCoolDown :: Int
}

addMarineBullet :: Player -> Marine -> Array EnemyBullet
addMarineBullet playerObject@(Player p) marine = if canFire && withinRange then [ newBullet ] else []
    where 
        withinRange = playerInRange playerObject marine
        canFire = canFireBullet marine
        v = normalise $ toVelocity $ vectorTo marine.pos p.pos
        scaledVelocity = { xSpeed: v.xSpeed * marineBulletSpeed, ySpeed: v.ySpeed * marineBulletSpeed} 
        newBullet = MarineBullet { 
            pos: marine.pos { y = marine.pos.y + (marine.sprite.size.height / 2) }, 
            velocity: scaledVelocity,
            sprite: S.bulletRight
        }

playerInRange :: Player -> Marine -> Boolean
playerInRange (Player p) marine = marineAgroRange > distanceBetween p.pos marine.pos

canFireBullet :: Marine -> Boolean
canFireBullet m = m.shotCoolDown == 0

updateMarine :: (Marine -> Boolean) -> X -> Player -> Marine -> Marine
updateMarine collisionCheck distance p marine = newMarine
    where
        newVelocityBasedOnGravity = updateVelocity marine.appear marine.velocity
        withinRange = playerInRange p marine
        canFire = canFireBullet marine
        newPositionBasedOnVelocity = updatePosition marine.pos newVelocityBasedOnGravity
        shotCoolDown = case canFire, withinRange of 
            true, true -> marineShotCooldown
            true, false -> 0
            false, _ -> marine.shotCoolDown - 1 
        marineBasedOnVelocity = {
            pos: newPositionBasedOnVelocity,
            sprite: incrementFrame marine.sprite,
            appear: marine.appear,
            velocity: newVelocityBasedOnGravity,
            shotCoolDown: shotCoolDown
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