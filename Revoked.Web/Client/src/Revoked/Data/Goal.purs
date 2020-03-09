module Revoked.Data.Goal where

import Prelude
import Emo8.Class.Object (class ObjectDraw, class Object, position, draw, size, scroll)
import Emo8.Action.Draw (drawSprite)
import Revoked.Constants (healthPackBonusHealth)
import Data.Foldable (sum)
import Data.Array (mapMaybe, head)
import Emo8.Types (Position, Sprite)
import Emo8.Data.Sprite (incrementFrame)
import Data.Maybe (Maybe(..))
import Revoked.Data.Gun (Gun, updateGun)

data Goal =    
    NextLevel { pos :: Position, sprite :: Sprite } |
    GunPickup Gun |
    HealthPack { pos :: Position, sprite :: Sprite }

instance goalEqual :: Eq Goal where
    eq (NextLevel nl1) (NextLevel nl2) = nl1 == nl2
    eq (GunPickup gp1) (GunPickup gp2) = gp1 == gp2
    eq (HealthPack hp1) (HealthPack hp2) = hp1 == hp2
    eq _ _ = false

instance goalShow :: Show Goal where
    show (NextLevel nl) = "NextLevel " <> show nl
    show (GunPickup gp) = "GunPickup " <> show gp
    show (HealthPack hp) = "HealthPack " <> show hp
 
instance objectGoal :: Object Goal where
    size (NextLevel nl) = nl.sprite.size
    size (HealthPack hp) = hp.sprite.size
    size (GunPickup gp) = size gp
    position (NextLevel nl) = nl.pos
    position (GunPickup gp) = position gp
    position (HealthPack hp) = hp.pos
    scroll offset (NextLevel nl) = NextLevel $ nl { pos = { x: nl.pos.x + offset, y: nl.pos.y }}
    scroll offset (GunPickup gp) = GunPickup $ scroll offset gp
    scroll offset (HealthPack hp) = HealthPack $ hp { pos = { x: hp.pos.x + offset, y: hp.pos.y }}

instance objectDrawGoal :: ObjectDraw Goal where
    draw (NextLevel nl) = drawSprite nl.sprite nl.pos.x nl.pos.y
    draw (GunPickup gp) = draw gp  
    draw (HealthPack hp) = drawSprite hp.sprite hp.pos.x hp.pos.y 

updateGoal :: Goal -> Goal
updateGoal (NextLevel nl) = NextLevel $ nl { sprite = incrementFrame nl.sprite }
updateGoal (GunPickup gp) = GunPickup $ updateGun gp
updateGoal (HealthPack hp) = HealthPack $ hp { sprite = incrementFrame hp.sprite }

isGunGoal :: Goal -> Boolean
isGunGoal (NextLevel _) = false
isGunGoal (GunPickup _) = true
isGunGoal (HealthPack _) = false

isNextLevelGoal :: Goal -> Boolean
isNextLevelGoal (NextLevel _) = true
isNextLevelGoal (GunPickup _) = false
isNextLevelGoal (HealthPack _) = false

mapToGun :: Goal -> Maybe Gun
mapToGun (NextLevel _) = Nothing
mapToGun (GunPickup gp) = Just gp
mapToGun (HealthPack _) = Nothing

mapToHealth :: Goal -> Int
mapToHealth (NextLevel _) = 0
mapToHealth (GunPickup _) = 0
mapToHealth (HealthPack _) = healthPackBonusHealth

toHealthBonus :: Array Goal -> Int
toHealthBonus goals = sum $ map mapToHealth goals

firstGun :: Array Goal -> Maybe Gun
firstGun goals = head guns
    where 
        guns = mapMaybe mapToGun goals
