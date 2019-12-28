module Data.Gun.Pistol where

import Prelude

import Assets.Sprites as S
import Emo8.Types (Position, Sprite, Deg)
import Constants (pistolShotCooldown, pistolMagazineSize)
import Data.Bullet (Bullet, newBullet, BulletAppear(..))

data PistolAppear = Left | Right 

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
        bullets : [ newBullet BulletForward p.pos ] 
    }
    false -> { 
        gun: p , 
        bullets: [] 
    }

reloadPistol :: Pistol -> Pistol
reloadPistol p = p { shotCoolDown = 0, shotCount = pistolMagazineSize }

canFire :: Pistol -> Boolean
canFire p = p.shotCoolDown == 0 && p.shotCount > 0