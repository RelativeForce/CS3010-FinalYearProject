module Data.Gun.Pistol where

import Prelude

import Assets.Sprites as S
import Emo8.Types (Position, Sprite, Deg)
import Constants (pistolShotCooldown, pistolMagazineSize)
import Data.Bullet (Bullet)
import Emo8.Data.Sprite (incrementFrame)
import Data.Gun.Helper (GunAppear(..), appearBasedOnAngle, newGunBullet)

type Pistol = { 
    pos :: Position,
    angle :: Deg,
    shotCoolDown :: Int,
    shotCount :: Int,
    appear :: GunAppear,
    sprite :: Sprite,
    infinte :: Boolean
}

fireAndUpdatePistol :: Pistol -> { gun :: Pistol, bullets :: Array Bullet }
fireAndUpdatePistol p = pistolAndBullets
    where 
        updatedPistol = updatePistol p
        pistolAndBullets = case canFire p of
            true -> { 
                gun: updatedPistol { shotCoolDown = pistolShotCooldown, shotCount = p.shotCount - 1 }, 
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
canFire p = p.shotCoolDown == 0 && (p.infinte || p.shotCount > 0)

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

defaultPistol :: Boolean -> Position -> Deg -> Pistol
defaultPistol infinte pos angle = pistol
    where 
        appear = appearBasedOnAngle angle
        sprite = spriteBasedOnAppear appear
        pistol = { 
            pos: pos,
            angle: angle,
            shotCoolDown: 0,
            shotCount: pistolMagazineSize,
            appear: appear,
            sprite: sprite,
            infinte: infinte
        }