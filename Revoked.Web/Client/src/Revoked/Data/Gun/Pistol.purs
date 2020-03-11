module Revoked.Data.Gun.Pistol where

import Prelude

import Emo8.Types (Position, Sprite, Deg)
import Emo8.Data.Sprite (incrementFrame)

import Revoked.Assets.Sprites as S
import Revoked.Constants (pistolShotCooldown)
import Revoked.Data.Bullet (Bullet)
import Revoked.Data.Gun.Helper (GunAppear(..), appearBasedOnAngle, newGunBullet)

-- | Denotes the state of a pistol which fires single 
-- | shots at a slow rate.
type Pistol = { 
    pos :: Position,
    angle :: Deg,
    shotCoolDown :: Int,
    appear :: GunAppear,
    sprite :: Sprite
}

-- | Updates a pistol and fires it if possible.
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

-- | Updates a pistol's sprite and de-incremenets the Pistols shot delay
updatePistol :: Pistol -> Pistol
updatePistol p = newPistol
    where
        newPistol = p {
            sprite = incrementFrame p.sprite,
            shotCoolDown = if p.shotCoolDown > 0 then p.shotCoolDown - 1 else 0
        }

-- | Retrieves which sprite should be used when the pistol is facing in 
-- | a given direction.
spriteBasedOnAppear :: GunAppear -> Sprite
spriteBasedOnAppear appear = case appear of
    Left -> S.pistolLeft
    Right -> S.pistolRight

-- | Whether or not the given pistol can fire
canFire :: Pistol -> Boolean
canFire p = p.shotCoolDown == 0

-- | Sets the position and rotation of a given pistol to the specified angle and position.
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

-- | Builds a Pistol with a given position and angle
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