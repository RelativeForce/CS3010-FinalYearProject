module Data.Gun.Shotgun where

import Prelude

import Assets.Sprites as S
import Emo8.Types (Position, Sprite, Deg)
import Constants (shotgunShotCooldown, shotgunMagazineSize)
import Data.Bullet (Bullet)
import Emo8.Data.Sprite (incrementFrame)
import Data.Gun.Helper (GunAppear(..), appearBasedOnAngle, newGunBullet)

type Shotgun = { 
    pos :: Position,
    angle :: Deg,
    shotCoolDown :: Int,
    shotCount :: Int,
    appear :: GunAppear,
    sprite :: Sprite
}

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

updateShotgun :: Shotgun -> Shotgun
updateShotgun p = newShotgun
    where
        newShotgun = p {
            sprite = incrementFrame p.sprite,
            shotCoolDown = if p.shotCoolDown > 0 then p.shotCoolDown - 1 else 0
        }

spriteBasedOnAppear :: GunAppear -> Sprite
spriteBasedOnAppear appear = case appear of
    Left -> S.shotgunLeft
    Right -> S.shotgunRight

canFire :: Shotgun -> Boolean
canFire p = p.shotCoolDown == 0 && p.shotCount > 0

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