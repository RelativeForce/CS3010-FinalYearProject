module Revoked.Data.Gun.AssaultRifle where

import Prelude

import Emo8.Types (Position, Sprite, Deg)
import Emo8.Data.Sprite (incrementFrame)

import Revoked.Assets.Sprites as S
import Revoked.Constants (assaultRifleShotCooldown, assaultRifleMagazineSize)
import Revoked.Data.Bullet (Bullet)
import Revoked.Data.Gun.Helper (GunAppear(..), appearBasedOnAngle, newGunBullet)

-- | Denotes the state of a assualt rifle which fires at 
-- | a fast fire rate.
type AssaultRifle = { 
    pos :: Position,
    angle :: Deg,
    shotCoolDown :: Int,
    shotCount :: Int,
    appear :: GunAppear,
    sprite :: Sprite
}

-- | Updates a assualt rifle and fires it if possible.
fireAndUpdateAssaultRifle :: AssaultRifle -> { gun :: AssaultRifle, bullets :: Array Bullet }
fireAndUpdateAssaultRifle p = assaultRifleAndBullets
    where 
        updatedAssaultRifle = updateAssaultRifle p
        assaultRifleAndBullets = case canFire p of
            true -> { 
                gun: updatedAssaultRifle { shotCoolDown = assaultRifleShotCooldown, shotCount = p.shotCount - 1 }, 
                bullets: [ newGunBullet p.angle p.pos p.sprite.size ] 
            }
            false -> { gun: updatedAssaultRifle, bullets: [] }

-- | Updates a assualt rifle's sprite and de-incremenets the assault rifle shot delay
updateAssaultRifle :: AssaultRifle -> AssaultRifle
updateAssaultRifle p = newAssaultRifle
    where
        newAssaultRifle = p {
            sprite = incrementFrame p.sprite,
            shotCoolDown = if p.shotCoolDown > 0 then p.shotCoolDown - 1 else 0
        }

-- | Retrieves which sprite should be used when the assault rifle is facing in 
-- | a given direction.
spriteBasedOnAppear :: GunAppear -> Sprite
spriteBasedOnAppear appear = case appear of
    Left -> S.assaultRifleLeft
    Right -> S.assaultRifleRight

-- | Whether or not the given assault rifle can fire
canFire :: AssaultRifle -> Boolean
canFire p = p.shotCoolDown == 0 && p.shotCount > 0

-- | Sets the position and rotation of a given assault rifle to the specified angle and position.
setAssaultRiflePositionAndRotation :: AssaultRifle -> Position -> Deg -> AssaultRifle
setAssaultRiflePositionAndRotation p pos angle = newAssaultRifle
    where
        newAppear = appearBasedOnAngle angle
        newSprite = if newAppear == p.appear 
            then p.sprite 
            else spriteBasedOnAppear newAppear
        newAssaultRifle = p { 
            pos = pos, 
            angle = angle,
            sprite = newSprite,
            appear = newAppear 
        }

-- | Builds a assault rifle with a given position and angle
defaultAssaultRifle :: Position -> Deg -> AssaultRifle
defaultAssaultRifle pos angle = assaultRifle
    where 
        appear = appearBasedOnAngle angle
        sprite = spriteBasedOnAppear appear
        assaultRifle = { 
            pos: pos,
            angle: angle,
            shotCoolDown: 0,
            shotCount: assaultRifleMagazineSize,
            appear: appear,
            sprite: sprite
        }