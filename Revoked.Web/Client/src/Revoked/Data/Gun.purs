module Data.Gun where

import Prelude

import Class.Object (class ObjectDraw, class Object, position)
import Data.Bullet (Bullet)
import Data.Gun.Pistol (Pistol, reloadPistol, fireAndUpdatePistol, updatePistol, defaultPistol)
import Emo8.Action.Draw (drawRotatedSprite)
import Emo8.Types (Position, Deg)

data Gun = PistolGun Pistol 

instance objectGun :: Object Gun where
    size (PistolGun p) = p.sprite.size
    position (PistolGun p) = p.pos
    scroll offset (PistolGun p) = PistolGun $ p { pos = { x: p.pos.x + offset, y: p.pos.y }}

instance objectDrawGun :: ObjectDraw Gun where
    draw o@(PistolGun p) = drawRotatedSprite p.sprite (position o).x (position o).y (mod p.angle 180)

fireAndUpdateGun :: Gun -> { gun :: Gun, bullets :: Array Bullet }
fireAndUpdateGun (PistolGun p) = (fireAndUpdatePistol >>> toGunAndBullets PistolGun) p

reloadGun :: Gun -> Gun
reloadGun (PistolGun p) = PistolGun $ reloadPistol p

updateGun :: Gun -> Gun 
updateGun (PistolGun p) = PistolGun $ updatePistol p

toGunAndBullets :: forall a. (a -> Gun) -> { gun :: a, bullets :: Array Bullet } -> { gun :: Gun, bullets :: Array Bullet }
toGunAndBullets mapper r = { gun: mapper r.gun, bullets: r.bullets }

setPositionAndRotation :: Gun -> Position -> Deg -> Gun
setPositionAndRotation (PistolGun p) pos angle = PistolGun $ p { pos = pos, angle = angle }

defaultPistolGun :: Position -> Deg -> Gun
defaultPistolGun p = PistolGun <<< defaultPistol p