module Data.Enemy where

import Prelude

import Class.Object (class ObjectDraw, class Object, position)
import Data.EnemyBullet (EnemyBullet(..))
import Data.Player (Player(..))
import Constants (marineWalkSpeed, gravity)
import Collision (adjustX)
import Emo8.Action.Draw (drawSprite)
import Emo8.Utils (updatePosition)
import Assets.Sprites as S
import Emo8.Types (Position, Score, Sprite, Velocity, X)
import Math (sqrt)
import Data.Int (toNumber)
import Emo8.Data.Sprite (incrementFrame)

data Enemy = EnemyMarine Marine

instance objectEnemy :: Object Enemy where
    size (EnemyMarine s) = s.sprite.size
    position (EnemyMarine s) = s.pos
    scroll offset (EnemyMarine s) = EnemyMarine $ s { pos = { x: s.pos.x + offset, y: s.pos.y }}

instance objectDrawEnemy :: ObjectDraw Enemy where
    draw o@(EnemyMarine m) = drawSprite m.sprite (position o).x (position o).y

enemyToScore :: Enemy -> Score
enemyToScore (EnemyMarine s) = 9

addEnemyBullet :: Player -> Enemy -> Array EnemyBullet
addEnemyBullet (Player p) (EnemyMarine e) = []

data MarineAppear = Standing | WalkingLeft | WalkingRight 

type Marine = { 
    pos :: Position,
    velocity :: Velocity,
    sprite :: Sprite,
    appear :: MarineAppear,
    shotCoolDown :: Int
}

updateEnemy :: (Enemy -> Boolean) -> X -> Player -> Enemy -> Enemy
updateEnemy collisionCheck distance playerObject (EnemyMarine marine) = EnemyMarine newMarine
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

distanceFromOrigin :: Position -> Number
distanceFromOrigin p = sqrt $ toNumber $ (p.x * p.x) + (p.y * p.y)

defaultMarine :: Position -> Enemy
defaultMarine pos = EnemyMarine {
    pos: pos,
    sprite: S.marineLeft,
    appear: WalkingLeft,
    velocity: {
        xSpeed: 0.0,
        ySpeed: 0.0
    },
    shotCoolDown: 0
}

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

collideMarine :: Position -> Marine -> X -> (Enemy -> Boolean) -> Marine
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
        xCollide = collisionCheck $ EnemyMarine xChangePlayer
        yCollideLeft = collisionCheck $ EnemyMarine yChangePlayerLeft
        yCollideRight = collisionCheck $ EnemyMarine yChangePlayerRight
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

velocityXBasedOnAppearance :: MarineAppear -> Number
velocityXBasedOnAppearance appear = case appear of
    WalkingLeft -> -marineWalkSpeed
    WalkingRight -> marineWalkSpeed
    Standing -> 0.0 

toMarine :: Enemy -> Marine
toMarine (EnemyMarine marine) = marine

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