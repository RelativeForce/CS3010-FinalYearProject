module Data.Gun.Blaster where

import Prelude

import Revoked.Assets.Sprites as S
import Emo8.Types (Position, Sprite, Deg)
import Data.Bullet (Bullet)
import Emo8.Data.Sprite (incrementFrame)
import Data.Gun.Helper (newGunBullet)
import Constants (blasterShotCooldown)

type Blaster = { 
    pos :: Position,
    angle :: Deg,
    shotCoolDown :: Int,
    sprite :: Sprite
}

fireAndUpdateBlaster :: Blaster -> { gun :: Blaster, bullets :: Array Bullet }
fireAndUpdateBlaster p = blasterAndBullets
    where 
        updatedBlaster = updateBlaster p
        blasterAndBullets = case canFire p of
            true -> { 
                gun: updatedBlaster { shotCoolDown = blasterShotCooldown }, 
                bullets: [ newGunBullet p.angle p.pos p.sprite.size ] 
            }
            false -> { gun: updatedBlaster, bullets: [] }

updateBlaster :: Blaster -> Blaster
updateBlaster p = newBlaster
    where
        newBlaster = p {
            sprite = incrementFrame p.sprite,
            shotCoolDown = if p.shotCoolDown > 0 then p.shotCoolDown - 1 else 0
        }

canFire :: Blaster -> Boolean
canFire p = p.shotCoolDown == 0

setBlasterPositionAndRotation :: Blaster -> Position -> Deg -> Blaster
setBlasterPositionAndRotation p pos angle = p { pos = pos, angle = angle }

defaultBlaster :: Position -> Deg -> Blaster
defaultBlaster pos angle = blaster
    where 
        blaster = { 
            pos: pos,
            angle: angle,
            shotCoolDown: 1,
            sprite: S.blaster
        }