module Revoked.Data.Gun.Pistol where

import Prelude

import Revoked.Assets.Sprites as S
import Emo8.Types (Position, Sprite, Deg)
import Revoked.Constants (pistolShotCooldown)
import Revoked.Data.Bullet (Bullet)
import Emo8.Data.Sprite (incrementFrame)
import Revoked.Data.Gun.Helper (GunAppear(..), appearBasedOnAngle, newGunBullet)

type Pistol = { 
    pos :: Position,
    angle :: Deg,
    shotCoolDown :: Int,
    appear :: GunAppear,
    sprite :: Sprite
}

fireAndUpdatePistol :: Pistol -> { gun :: Pistol, bullets :: Array Bullet }
fireAndUpdatePistol p = pistolAndBullets
    where 
        updatedPistol = updatePistol p
        pistolAndBullets = case canFire p of
            true -> { 
                gun: updatedPistol { shotCoolDown = pistolShotCooldown }, 
                bullets: [ newGunBullet p.angle p.pos p.sprite.size ] 
            }
            false -> { gun: updatedPistol, bullets: [] }

updatePistol :: Pistol -> Pistol
updatePistol p = newPistol
    where
        newPistol = p {
            sprite = incrementFrame p.sprite,
            shotCoolDown = if p.shotCoolDown > 0 then p.shotCoolDown - 1 else 0
        }

spriteBasedOnAppear :: GunAppear -> Sprite
spriteBasedOnAppear appear = case appear of
    Left -> S.pistolLeft
    Right -> S.pistolRight

canFire :: Pistol -> Boolean
canFire p = p.shotCoolDown == 0

setPistolPositionAndRotation :: Pistol -> Position -> Deg -> Pistol
setPistolPositionAndRotation p pos angle = newPistol
    where
        newAppear = appearBasedOnAngle angle
        newSprite = if newAppear == p.appear 
            then p.sprite 
            else spriteBasedOnAppear newAppear
        newPistol = p { 
            pos = pos, 
            angle = angle,
            sprite = newSprite,
            appear = newAppear 
        }

defaultPistol :: Position -> Deg -> Pistol
defaultPistol pos angle = pistol
    where 
        appear = appearBasedOnAngle angle
        sprite = spriteBasedOnAppear appear
        pistol = { 
            pos: pos,
            angle: angle,
            shotCoolDown: 0,
            appear: appear,
            sprite: sprite
        }