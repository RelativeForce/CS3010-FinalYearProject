module Data.Gun.AssaultRifle where

import Prelude

import Revoked.Assets.Sprites as S
import Emo8.Types (Position, Sprite, Deg)
import Revoked.Constants (assaultRifleShotCooldown, assaultRifleMagazineSize)
import Data.Bullet (Bullet)
import Emo8.Data.Sprite (incrementFrame)
import Data.Gun.Helper (GunAppear(..), appearBasedOnAngle, newGunBullet)

type AssaultRifle = { 
    pos :: Position,
    angle :: Deg,
    shotCoolDown :: Int,
    shotCount :: Int,
    appear :: GunAppear,
    sprite :: Sprite
}

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

updateAssaultRifle :: AssaultRifle -> AssaultRifle
updateAssaultRifle p = newAssaultRifle
    where
        newAssaultRifle = p {
            sprite = incrementFrame p.sprite,
            shotCoolDown = if p.shotCoolDown > 0 then p.shotCoolDown - 1 else 0
        }

spriteBasedOnAppear :: GunAppear -> Sprite
spriteBasedOnAppear appear = case appear of
    Left -> S.assaultRifleLeft
    Right -> S.assaultRifleRight

canFire :: AssaultRifle -> Boolean
canFire p = p.shotCoolDown == 0 && p.shotCount > 0

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