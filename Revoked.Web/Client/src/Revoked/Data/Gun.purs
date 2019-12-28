module Data.Gun where

import Prelude

import Class.Object (class ObjectDraw, class Object, position)
import Data.Bullet (Bullet)
import Data.Gun.Pistol (Pistol, reloadPistol, firePistol, updatePistol)
import Emo8.Action.Draw (drawRotatedSprite)

data Gun = PistolGun Pistol 

instance objectGun :: Object Gun where
    size (PistolGun p) = p.sprite.size
    position (PistolGun p) = p.pos
    scroll offset (PistolGun p) = PistolGun $ p { pos = { x: p.pos.x + offset, y: p.pos.y }}

instance objectDrawGun :: ObjectDraw Gun where
    draw o@(PistolGun p) = drawRotatedSprite p.sprite (position o).x (position o).y p.angle

fireGun :: Gun -> { gun :: Gun, bullets :: Array Bullet }
fireGun (PistolGun p) = (firePistol >>> toGunAndBullets PistolGun) p

reloadGun :: Gun -> Gun
reloadGun (PistolGun p) = PistolGun $ reloadPistol p

updateGun :: Gun -> Gun 
updateGun (PistolGun p) = PistolGun $ updatePistol p

toGunAndBullets :: forall a. (a -> Gun) -> { gun :: a, bullets :: Array Bullet } -> { gun :: Gun, bullets :: Array Bullet }
toGunAndBullets mapper r = { gun: mapper r.gun, bullets: r.bullets }