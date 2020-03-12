module Revoked.Data.Gun.Blaster where

import Prelude

import Emo8.Types (Position, Sprite, Deg)
import Emo8.Data.Sprite (incrementFrame)

import Revoked.Assets.Sprites as S
import Revoked.Data.Bullet (Bullet)
import Revoked.Data.Gun.Helper (newGunBullet)
import Revoked.Constants (blasterShotCooldown)

-- | Denotes the state of a blaster which fires single 
-- | shots at a slow rate.
type Blaster = { 
    pos :: Position,
    angle :: Deg,
    shotCoolDown :: Int,
    sprite :: Sprite
}

-- | Updates a blaster and fires it if possible.
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

-- | Updates a blaster's sprite and de-incremenets the blaster shot delay
updateBlaster :: Blaster -> Blaster
updateBlaster p = newBlaster
    where
        newBlaster = p {
            sprite = incrementFrame p.sprite,
            shotCoolDown = if p.shotCoolDown > 0 then p.shotCoolDown - 1 else 0
        }

-- | Whether or not the given blaster can fire
canFire :: Blaster -> Boolean
canFire p = p.shotCoolDown == 0

-- | Sets the position and rotation of a given blaster to the specified angle and position.
setBlasterPositionAndRotation :: Blaster -> Position -> Deg -> Blaster
setBlasterPositionAndRotation p pos angle = p { pos = pos, angle = angle }

-- | Builds a Blaster with a given position and angle
defaultBlaster :: Position -> Deg -> Blaster
defaultBlaster pos angle = blaster
    where 
        blaster = { 
            pos: pos,
            angle: angle,
            shotCoolDown: 1,
            sprite: S.blaster
        }