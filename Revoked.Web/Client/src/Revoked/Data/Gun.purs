module Data.Gun where

import Prelude

import Class.Object (class ObjectDraw, class Object, position)
import Data.Bullet (Bullet)
import Data.Gun.Pistol (Pistol, fireAndUpdatePistol, updatePistol, defaultPistol, setPistolPositionAndRotation)
import Data.Gun.Shotgun (Shotgun, defaultShotgun, fireAndUpdateShotgun, setShotgunPositionAndRotation, updateShotgun)
import Data.Gun.AssaultRifle (AssaultRifle, defaultAssaultRifle, fireAndUpdateAssaultRifle, setAssaultRiflePositionAndRotation, updateAssaultRifle)
import Emo8.Action.Draw (drawRotatedSprite)
import Emo8.Types (Position, Deg)

data Gun = 
    PistolGun Pistol |
    ShotgunGun Shotgun |
    AssaultRifleGun AssaultRifle

instance objectGun :: Object Gun where
    size (PistolGun p) = p.sprite.size
    size (ShotgunGun sg) = sg.sprite.size
    size (AssaultRifleGun ar) = ar.sprite.size
    position (PistolGun p) = p.pos
    position (ShotgunGun sg) = sg.pos
    position (AssaultRifleGun ar) = ar.pos
    scroll offset (PistolGun p) = PistolGun $ p { pos = { x: p.pos.x + offset, y: p.pos.y }}
    scroll offset (ShotgunGun sg) = ShotgunGun $ sg { pos = { x: sg.pos.x + offset, y: sg.pos.y }}
    scroll offset (AssaultRifleGun ar) = AssaultRifleGun $ ar { pos = { x: ar.pos.x + offset, y: ar.pos.y }}

instance objectDrawGun :: ObjectDraw Gun where
    draw o@(PistolGun p) = drawRotatedSprite p.sprite (position o).x (position o).y p.angle
    draw o@(ShotgunGun sg) = drawRotatedSprite sg.sprite (position o).x (position o).y sg.angle
    draw o@(AssaultRifleGun ar) = drawRotatedSprite ar.sprite (position o).x (position o).y ar.angle

fireAndUpdateGun :: Gun -> { gun :: Gun, bullets :: Array Bullet }
fireAndUpdateGun (PistolGun p) = (fireAndUpdatePistol >>> toGunAndBullets PistolGun) p
fireAndUpdateGun (ShotgunGun sg) = (fireAndUpdateShotgun >>> toGunAndBullets ShotgunGun) sg
fireAndUpdateGun (AssaultRifleGun ar) = (fireAndUpdateAssaultRifle >>> toGunAndBullets AssaultRifleGun) ar

updateGun :: Gun -> Gun 
updateGun (PistolGun p) = PistolGun $ updatePistol p
updateGun (ShotgunGun sg) = ShotgunGun $ updateShotgun sg
updateGun (AssaultRifleGun ar) = AssaultRifleGun $ updateAssaultRifle ar

shotCount :: Gun -> Int 
shotCount (PistolGun p) = if p.infinte then 99999 else p.shotCount
shotCount (ShotgunGun sg) = sg.shotCount
shotCount (AssaultRifleGun ar) = ar.shotCount

isInfinite :: Gun -> Boolean 
isInfinite (PistolGun p) = p.infinte
isInfinite (ShotgunGun sg) = false
isInfinite (AssaultRifleGun ar) = false

toGunAndBullets :: forall a. (a -> Gun) -> { gun :: a, bullets :: Array Bullet } -> { gun :: Gun, bullets :: Array Bullet }
toGunAndBullets mapper r = { gun: mapper r.gun, bullets: r.bullets }

setPositionAndRotation :: Gun -> Position -> Deg -> Gun
setPositionAndRotation (PistolGun p) pos angle = PistolGun $ setPistolPositionAndRotation p pos angle 
setPositionAndRotation (ShotgunGun sg) pos angle = ShotgunGun $ setShotgunPositionAndRotation sg pos angle 
setPositionAndRotation (AssaultRifleGun ar) pos angle = AssaultRifleGun $ setAssaultRiflePositionAndRotation ar pos angle 

defaultPistolGun :: Boolean -> Position -> Deg -> Gun
defaultPistolGun infinte pos angle = PistolGun $ defaultPistol infinte pos angle

defaultShotgunGun :: Position -> Deg -> Gun
defaultShotgunGun pos angle = ShotgunGun $ defaultShotgun pos angle

defaultAssaultRifleGun :: Position -> Deg -> Gun
defaultAssaultRifleGun pos angle = AssaultRifleGun $ defaultAssaultRifle pos angle