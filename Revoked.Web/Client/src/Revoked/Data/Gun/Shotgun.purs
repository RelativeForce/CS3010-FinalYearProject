module Data.Gun.Shotgun where

import Prelude

import Assets.Sprites as S
import Emo8.Types (Position, Sprite, Deg, Size, Velocity)
import Constants (shotgunShotCooldown, shotgunMagazineSize, bulletSpeed)
import Data.Bullet (Bullet, newBullet)
import Emo8.Data.Sprite (incrementFrame)
import Emo8.Utils (xComponent, yComponent, inLeftDirection)
import Data.Int (toNumber, floor)

data ShotgunAppear = ShotgunLeft | ShotgunRight 

instance shotgunAppearEqual :: Eq ShotgunAppear where
    eq (ShotgunLeft) (ShotgunLeft) = true
    eq (ShotgunRight) (ShotgunRight) = true
    eq _ _ = false

type Shotgun = { 
    pos :: Position,
    angle :: Deg,
    shotCoolDown :: Int,
    shotCount :: Int,
    appear :: ShotgunAppear,
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
                    shotgunBullet (p.angle - 20) p.pos p.sprite.size,
                    shotgunBullet (p.angle - 8) p.pos p.sprite.size,
                    shotgunBullet (p.angle) p.pos p.sprite.size,
                    shotgunBullet (p.angle + 8) p.pos p.sprite.size,
                    shotgunBullet (p.angle + 20) p.pos p.sprite.size 
                ] 
            }
            false -> { gun: updatedShotgun, bullets: [] }

reloadShotgun :: Shotgun -> Shotgun
reloadShotgun p = p { shotCoolDown = 0, shotCount = shotgunMagazineSize }

updateShotgun :: Shotgun -> Shotgun
updateShotgun p = newShotgun
    where
        newShotgun = p {
            sprite = incrementFrame p.sprite,
            shotCoolDown = if p.shotCoolDown > 0 then p.shotCoolDown - 1 else 0
        }

appearBasedOnAngle :: Deg -> ShotgunAppear
appearBasedOnAngle angle = if inLeftDirection angle then ShotgunLeft else ShotgunRight

spriteBasedOnAppear :: ShotgunAppear -> Sprite
spriteBasedOnAppear appear = case appear of
    ShotgunLeft -> S.shotgunLeft
    ShotgunRight -> S.shotgunRight

canFire :: Shotgun -> Boolean
canFire p = p.shotCoolDown == 0 && p.shotCount > 0

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

shotgunBullet :: Deg -> Position -> Size -> Bullet
shotgunBullet angle pos s = bullet
    where
        velocity = bulletVelocity angle
        position = bulletPosition angle pos s
        bullet = newBullet position velocity 

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