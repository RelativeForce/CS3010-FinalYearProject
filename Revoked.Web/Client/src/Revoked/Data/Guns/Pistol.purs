module Data.Gun.Pistol where

import Prelude

import Assets.Sprites as S
import Emo8.Types (Position, Sprite, Deg)
import Constants (pistolShotCooldown, pistolMagazineSize)
import Data.Bullet (Bullet, newBullet, BulletAppear(..))
import Emo8.Data.Sprite (incrementFrame)

data PistolAppear = PistolLeft | PistolRight 

instance pistolAppearEqual :: Eq PistolAppear where
    eq (PistolLeft) (PistolLeft) = true
    eq (PistolRight) (PistolRight) = true
    eq _ _ = false

type Pistol = { 
    pos :: Position,
    angle :: Deg,
    shotCoolDown :: Int,
    shotCount :: Int,
    appear :: PistolAppear,
    sprite :: Sprite
}

firePistol :: Pistol -> { gun :: Pistol, bullets :: Array Bullet }
firePistol p = case canFire p of
    true -> { 
        gun: p { 
            shotCoolDown = pistolShotCooldown,
            shotCount = p.shotCount - 1
        }, 
        bullets : [ pistolBullet p.appear p.pos ] 
    }
    false -> { 
        gun: p , 
        bullets: [] 
    }

reloadPistol :: Pistol -> Pistol
reloadPistol p = p { shotCoolDown = 0, shotCount = pistolMagazineSize }

updatePistol :: Pistol -> Pistol
updatePistol p = newPistol
    where
        newAppear = appearBasedOnAngle p.angle
        newSprite = if newAppear == p.appear 
            then incrementFrame p.sprite 
            else spriteBasedOnAppear newAppear
        newPistol = p {
            sprite = newSprite,
            shotCoolDown = if p.shotCoolDown > 0 then p.shotCoolDown - 1 else 0,
            appear = newAppear
        }

appearBasedOnAngle :: Deg -> PistolAppear
appearBasedOnAngle angle = if angle > 180 then PistolLeft else PistolRight

spriteBasedOnAppear :: PistolAppear -> Sprite
spriteBasedOnAppear appear = case appear of
    PistolLeft -> S.bulletLeft
    PistolRight ->  S.bulletRight

canFire :: Pistol -> Boolean
canFire p = p.shotCoolDown == 0 && p.shotCount > 0

pistolBullet :: PistolAppear -> Position -> Bullet
pistolBullet appear pos = bullet
    where
        bulletAppear = case appear of
            PistolLeft -> BulletBackward
            PistolRight -> BulletForward
        bullet = newBullet bulletAppear pos

defaultPistol :: Position -> Deg -> Pistol
defaultPistol pos angle = pistol
    where 
        appear = appearBasedOnAngle angle
        sprite = spriteBasedOnAppear appear
        pistol = { 
            pos: pos,
            angle: angle,
            shotCoolDown: 0,
            shotCount: pistolMagazineSize,
            appear: appear,
            sprite: sprite
        }