module Data.Gun where

import Prelude

import Class.Object (class ObjectDraw, class Object, position)
import Data.Bullet (Bullet)
import Data.Gun.Pistol (Pistol, reloadPistol, fireAndUpdatePistol, updatePistol, defaultPistol, setPistolPositionAndRotation)
import Data.Gun.Shotgun (Shotgun, defaultShotgun, fireAndUpdateShotgun, reloadShotgun, setShotgunPositionAndRotation, updateShotgun)
import Emo8.Action.Draw (drawRotatedSprite)
import Emo8.Types (Position, Deg)

data Gun = 
    PistolGun Pistol |
    ShotgunGun Shotgun

instance objectGun :: Object Gun where
    size (PistolGun p) = p.sprite.size
    size (ShotgunGun sg) = sg.sprite.size
    position (PistolGun p) = p.pos
    position (ShotgunGun sg) = sg.pos
    scroll offset (PistolGun p) = PistolGun $ p { pos = { x: p.pos.x + offset, y: p.pos.y }}
    scroll offset (ShotgunGun sg) = ShotgunGun $ sg { pos = { x: sg.pos.x + offset, y: sg.pos.y }}

instance objectDrawGun :: ObjectDraw Gun where
    draw o@(PistolGun p) = drawRotatedSprite p.sprite (position o).x (position o).y p.angle
    draw o@(ShotgunGun sg) = drawRotatedSprite sg.sprite (position o).x (position o).y sg.angle

fireAndUpdateGun :: Gun -> { gun :: Gun, bullets :: Array Bullet }
fireAndUpdateGun (PistolGun p) = (fireAndUpdatePistol >>> toGunAndBullets PistolGun) p
fireAndUpdateGun (ShotgunGun sg) = (fireAndUpdateShotgun >>> toGunAndBullets ShotgunGun) sg

reloadGun :: Gun -> Gun
reloadGun (PistolGun p) = PistolGun $ reloadPistol p
reloadGun (ShotgunGun sg) = ShotgunGun $ reloadShotgun sg

updateGun :: Gun -> Gun 
updateGun (PistolGun p) = PistolGun $ updatePistol p
updateGun (ShotgunGun sg) = ShotgunGun $ updateShotgun sg

shotCount :: Gun -> Int 
shotCount (PistolGun p) = if p.infinte then 99999 else p.shotCount
shotCount (ShotgunGun sg) = sg.shotCount

isInfinite :: Gun -> Boolean 
isInfinite (PistolGun p) = p.infinte
isInfinite (ShotgunGun sg) = false

toGunAndBullets :: forall a. (a -> Gun) -> { gun :: a, bullets :: Array Bullet } -> { gun :: Gun, bullets :: Array Bullet }
toGunAndBullets mapper r = { gun: mapper r.gun, bullets: r.bullets }

setPositionAndRotation :: Gun -> Position -> Deg -> Gun
setPositionAndRotation (PistolGun p) pos angle = PistolGun $ setPistolPositionAndRotation p pos angle 
setPositionAndRotation (ShotgunGun sg) pos angle = ShotgunGun $ setShotgunPositionAndRotation sg pos angle 

defaultPistolGun :: Boolean -> Position -> Deg -> Gun
defaultPistolGun infinte pos angle = PistolGun $ defaultPistol infinte pos angle

defaultShotgunGun :: Position -> Deg -> Gun
defaultShotgunGun pos angle = ShotgunGun $ defaultShotgun pos angle