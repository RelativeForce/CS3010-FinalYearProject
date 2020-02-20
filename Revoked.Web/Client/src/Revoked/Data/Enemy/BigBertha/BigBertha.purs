module Data.Enemy.BigBertha where

import Prelude

import Assets.Sprites as S
import Class.Object (size)
import Data.Bullet (Bullet)
import Data.Player (Player(..))
import Constants (bigBerthaAccuracyDeviationIncrements, bigBerthaSpeed)
import Emo8.Data.Sprite (incrementFrame)
import Data.Array (length)
import Data.Int (floor)
import Emo8.Types (Position, Sprite, Velocity, X, Deg)
import Emo8.Utils (vectorTo, angle)

data Phase = Phase1 | Phase2 | Phase3 | Dead

type BigBertha = { 
    health :: Int,
    phase :: Phase,
    immuneCooldown :: Int
}

transitionPhase :: BigBertha -> BigBertha
transitionPhase bb = bb { phase = phase, immuneCooldown = immuneCooldown }
    where
        goToNext = shouldTransition bb  
        phase = if goToNext then nextPhase bb.phase else bb.phase
        immuneCooldown = if goToNext then 60 else bb.immuneCooldown

isImmune :: BigBertha -> Boolean
isImmune bb = bb.immuneCooldown <= 0

damageBigBertha :: BigBertha -> Int -> BigBertha
damageBigBertha bb healthLoss = bb { health = newHealth }
    where  
        hg = healthGate bb.phase
        damageAppliedHealth = (bb.health - healthLoss)
        newHealth = if damageAppliedHealth < hg then hg else damageAppliedHealth

shouldTransition :: BigBertha -> Boolean
shouldTransition bb = isAtHealthGate && noImmuneCooldown
    where
        isAtHealthGate = bb.health == healthGate bb.phase
        noImmuneCooldown = not $ isImmune bb

healthGate :: Phase -> Int
healthGate (Phase1) = 10
healthGate (Phase2) = 5
healthGate _ = 0

nextPhase :: Phase -> Phase
nextPhase (Phase1) = phase2
nextPhase _ = phase3

phase1 :: Phase
phase1 = Phase1

phase2 :: Phase
phase2 = Phase2

phase3 :: Phase
phase3 = Phase3

updateBigBertha :: X -> Player -> BigBertha -> { enemy :: BigBertha, bullets :: Array Bullet }
updateBigBertha distance p bigBertha = { enemy: newBigBertha, bullets: newBullets } 
    where
        { gun: potentialyFiredGun, bullets: newBullets } = fireAndUpdateGun bigBertha.gun
        hasFired = (length newBullets) > 0
        newOffset = if hasFired then mod (bigBertha.offset + 1) maxOffset else bigBertha.offset
        updatedMotionBigBertha = updatePositionAndVelocity bigBertha
        bigBerthaBasedOnVelocity = updatedMotionBigBertha {
            sprite = updateSprite bigBertha updatedMotionBigBertha,
            offset = newOffset,
            gun = potentialyFiredGun
        }
        gunAngle = angleOffset (angleToPlayer p bigBerthaBasedOnVelocity) newOffset
        newBigBertha = adjustGunPosition bigBerthaBasedOnVelocity gunAngle

updateSprite :: BigBertha -> BigBertha -> Sprite
updateSprite bigBertha newBigBertha = newSprite
    where 
        sameDirection = newBigBertha.velocity.xSpeed == bigBertha.velocity.xSpeed
        newSprite = if sameDirection 
            then incrementFrame bigBertha.sprite 
            else if newBigBertha.velocity.xSpeed < 0.0 
                then S.bigBerthaLeft 
                else S.bigBerthaRight

adjustGunPosition :: BigBertha -> Deg -> BigBertha
adjustGunPosition m a = marinWithAdjustedGun
    where 
        gunSize = size m.gun
        gunPosX = m.pos.x + (m.sprite.size.width / 2)
        gunPosY = m.pos.y + 5
        gunPos = { x: gunPosX, y: gunPosY }
        marinWithAdjustedGun = m {
            gun = setPositionAndRotation m.gun gunPos a
        }

updateVelocity :: Position -> Position -> Position -> Velocity -> Velocity
updateVelocity leftLimit rightLimit currentPosition currentVelocity = { xSpeed: xSpeed, ySpeed: ySpeed }
    where
        newX = currentPosition.x + floor currentVelocity.xSpeed
        newY = currentPosition.y + floor currentVelocity.ySpeed
        xSpeed = if newX < leftLimit.x then bigBerthaSpeed else if newX > rightLimit.x then -bigBerthaSpeed else currentVelocity.xSpeed
        ySpeed = if newY < leftLimit.y then bigBerthaSpeed else if newY > rightLimit.y then -bigBerthaSpeed else currentVelocity.ySpeed

updatePosition :: Position -> Position -> Position -> Velocity -> Position
updatePosition leftLimit rightLimit currentPosition currentVelocity = { x: x, y: y }
    where
        newX = currentPosition.x + floor currentVelocity.xSpeed
        newY = currentPosition.y + floor currentVelocity.ySpeed
        x = if newX < leftLimit.x then leftLimit.x else if newX > rightLimit.x then rightLimit.x else newX
        y = if newY < leftLimit.y then leftLimit.y else if newY > rightLimit.y then rightLimit.y else newY

updatePositionAndVelocity :: BigBertha -> BigBertha
updatePositionAndVelocity bigBertha = bigBertha { pos = newPos, velocity = newVelocity }
    where
        newPos = updatePosition bigBertha.leftLimit bigBertha.rightLimit bigBertha.pos bigBertha.velocity
        newVelocity = updateVelocity bigBertha.leftLimit bigBertha.rightLimit bigBertha.pos bigBertha.velocity

ensureLeftLimit :: Position -> Position -> Position
ensureLeftLimit leftLimit rightLimit  = if leftLimit.x < rightLimit.x then leftLimit else rightLimit

ensureRightLimit :: Position -> Position -> Position
ensureRightLimit leftLimit rightLimit  = if leftLimit.x > rightLimit.x then leftLimit else rightLimit

defaultBigBertha :: Int -> Position -> Position -> BigBertha
defaultBigBertha bigBerthaHealth leftLimit rightLimit = {
    pos: leftLimit,
    leftLimit: ensureLeftLimit leftLimit rightLimit,
    rightLimit: ensureRightLimit leftLimit rightLimit,
    sprite: S.bigBerthaRight,
    velocity: {
        xSpeed: bigBerthaSpeed,
        ySpeed: bigBerthaSpeed
    },
    offset: 0,
    gun: defaultBlasterGun leftLimit 270,
    health: bigBerthaHealth
}

