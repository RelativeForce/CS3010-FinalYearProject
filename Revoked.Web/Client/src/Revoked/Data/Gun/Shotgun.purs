module Revoked.Data.Gun.Shotgun where

import Prelude

import Emo8.Types (Position, Sprite, Deg)
import Emo8.Data.Sprite (incrementFrame)

import Revoked.Assets.Sprites as S
import Revoked.Constants (shotgunShotCooldown, shotgunMagazineSize)
import Revoked.Data.Bullet (Bullet)
import Revoked.Data.Gun.Helper (GunAppear(..), appearBasedOnAngle, newGunBullet)

-- | Denotes the state of a Shotgun which fires a spread 
-- | of 5 shots at a slow rate.
type Shotgun = { 
    pos :: Position,
    angle :: Deg,
    shotCoolDown :: Int,
    shotCount :: Int,
    appear :: GunAppear,
    sprite :: Sprite
}

-- | Updates a shotgun and fires it if possible.
fireAndUpdateShotgun :: Shotgun -> { gun :: Shotgun, bullets :: Array Bullet }
fireAndUpdateShotgun p = shotgunAndBullets
    where 
        updatedShotgun = updateShotgun p
        shotgunAndBullets = case canFire p of
            true -> { 
                gun: updatedShotgun { shotCoolDown = shotgunShotCooldown, shotCount = p.shotCount - 1 }, 
                bullets: [ 
                    newGunBullet (p.angle - 20) p.pos p.sprite.size,
                    newGunBullet (p.angle - 8) p.pos p.sprite.size,
                    newGunBullet (p.angle) p.pos p.sprite.size,
                    newGunBullet (p.angle + 8) p.pos p.sprite.size,
                    newGunBullet (p.angle + 20) p.pos p.sprite.size 
                ] 
            }
            false -> { gun: updatedShotgun, bullets: [] }

-- | Updates a shotgun's sprite and de-incremenets the shotgun shot delay
updateShotgun :: Shotgun -> Shotgun
updateShotgun p = newShotgun
    where
        newShotgun = p {
            sprite = incrementFrame p.sprite,
            shotCoolDown = if p.shotCoolDown > 0 then p.shotCoolDown - 1 else 0
        }

-- | Retrieves which sprite should be used when the shotgun is facing in 
-- | a given direction.
spriteBasedOnAppear :: GunAppear -> Sprite
spriteBasedOnAppear appear = case appear of
    Left -> S.shotgunLeft
    Right -> S.shotgunRight

-- | Whether or not the given shotgun can fire
canFire :: Shotgun -> Boolean
canFire p = p.shotCoolDown == 0 && p.shotCount > 0


-- | Sets the position and rotation of a given shotgun to the specified angle and position.
setShotgunPositionAndRotation :: Shotgun -> Position -> Deg -> Shotgun
setShotgunPositionAndRotation shotgun pos angle = newShotgun
    where
        newAppear = appearBasedOnAngle angle
        newSprite = if newAppear == shotgun.appear 
            then shotgun.sprite 
            else spriteBasedOnAppear newAppear
        newShotgun = shotgun { 
            pos = pos, 
            angle = angle,
            sprite = newSprite,
            appear = newAppear 
        }

-- | Builds a Shotgun with a given position and angle. It starts with 
-- | the deafult numbe of shots.
defaultShotgun :: Position -> Deg -> Shotgun
defaultShotgun pos angle = shotgun
    where 
        appear = appearBasedOnAngle angle
        sprite = spriteBasedOnAppear appear
        shotgun = { 
            pos: pos,
            angle: angle,
            shotCoolDown: 0,
            shotCount: shotgunMagazineSize,
            appear: appear,
            sprite: sprite
        }