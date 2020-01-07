module Data.Gun.Pistol where

import Prelude

import Assets.Sprites as S
import Emo8.Types (Position, Sprite, Deg, Size, Velocity)
import Constants (pistolShotCooldown, pistolMagazineSize, bulletSpeed)
import Data.Bullet (Bullet, newBullet)
import Emo8.Data.Sprite (incrementFrame)
import Emo8.Utils (xComponent, yComponent, inLeftDirection)
import Data.Int (toNumber, floor)

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
                bullets: [ pistolBullet p.angle p.pos p.sprite.size ] 
            }
            false -> { gun: updatedPistol, bullets: [] }

reloadPistol :: Pistol -> Pistol
reloadPistol p = p { shotCoolDown = 0, shotCount = pistolMagazineSize }

updatePistol :: Pistol -> Pistol
updatePistol p = newPistol
    where
        newPistol = p {
            sprite = incrementFrame p.sprite,
            shotCoolDown = if p.shotCoolDown > 0 then p.shotCoolDown - 1 else 0
        }

appearBasedOnAngle :: Deg -> PistolAppear
appearBasedOnAngle angle = if inLeftDirection angle then PistolLeft else PistolRight

spriteBasedOnAppear :: PistolAppear -> Sprite
spriteBasedOnAppear appear = case appear of
    PistolLeft -> S.pistolLeft
    PistolRight -> S.pistolRight

canFire :: Pistol -> Boolean
canFire p = p.shotCoolDown == 0 && (p.infinte || p.shotCount > 0)

bulletVelocity :: Deg -> Velocity
bulletVelocity angle = velocity
    where
        velocity = {
            xSpeed: xComponent angle bulletSpeed,
            ySpeed: yComponent angle bulletSpeed
        }

bulletPosition :: Deg -> Position -> Size -> Position
bulletPosition angle pos size = { x: x, y: y }
    where 
        x = if inLeftDirection angle
                then pos.x + floor (xComponent angle (toNumber size.width))
                else pos.x + floor (xComponent angle (toNumber size.width))
        y = if inLeftDirection angle
                then pos.y + size.height + (floor (yComponent angle (toNumber size.width)))
                else pos.y + floor (yComponent angle (toNumber size.width))

pistolBullet :: Deg -> Position -> Size -> Bullet
pistolBullet angle pos s = bullet
    where
        velocity = bulletVelocity angle
        position = bulletPosition angle pos s
        bullet = newBullet position velocity 

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