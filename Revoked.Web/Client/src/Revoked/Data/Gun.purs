module Data.Gun where

import Prelude

import Class.Object (class ObjectDraw, class Object, position)
import Data.Bullet (Bullet)
import Emo8.Action.Draw (drawSprite)
import Data.Gun.Pistol (Pistol, reloadPistol, firePistol)
import Emo8.Data.Sprite (incrementFrame)

data Gun = PistolGun Pistol 

instance objectGun :: Object Gun where
    size (PistolGun p) = p.sprite.size
    position (PistolGun p) = p.pos
    scroll offset (PistolGun p) = PistolGun $ p { pos = { x: p.pos.x + offset, y: p.pos.y }}

instance objectDrawGun :: ObjectDraw Gun where
    draw o@(PistolGun m) = drawSprite m.sprite (position o).x (position o).y

fireGun :: Gun -> { gun :: Gun, bullets :: Array Bullet }
fireGun (PistolGun p) = (firePistol >>> (toGunAndBullets PistolGun)) p

reloadGun :: Gun -> Gun
reloadGun (PistolGun p) = PistolGun $ reloadPistol p

updateGun :: Gun -> Gun 
updateGun (PistolGun p) = PistolGun $ p { sprite = incrementFrame p.sprite }

toGunAndBullets :: forall a. (a -> Gun) -> { gun :: a, bullets :: Array Bullet } -> { gun :: Gun, bullets :: Array Bullet }
toGunAndBullets mapper r = { gun: mapper r.gun, bullets: r.bullets }