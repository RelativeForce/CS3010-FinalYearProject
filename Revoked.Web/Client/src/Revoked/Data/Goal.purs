module Data.Goal where

import Prelude
import Class.Object (class ObjectDraw, class Object, position, draw, size, scroll)
import Emo8.Action.Draw (drawSprite)
import Data.Array (mapMaybe, head)
import Emo8.Types (Position, Sprite)
import Emo8.Data.Sprite (incrementFrame)
import Data.Maybe (Maybe(..))
import Data.Gun (Gun, updateGun)

data Goal =    
    NextLevel { pos :: Position, sprite :: Sprite } |
    GunPickup Gun 
 
instance objectGoal :: Object Goal where
    size (NextLevel nl) = nl.sprite.size
    size (GunPickup gp) = size gp
    position (NextLevel nl) = nl.pos
    position (GunPickup gp) = position gp
    scroll offset (NextLevel nl) = NextLevel $ nl { pos = { x: nl.pos.x + offset, y: nl.pos.y }}
    scroll offset (GunPickup gp) = GunPickup $ scroll offset gp

instance objectDrawGoal :: ObjectDraw Goal where
    draw (NextLevel nl) = drawSprite nl.sprite nl.pos.x nl.pos.y
    draw (GunPickup gp) = draw gp   

updateGoal :: Goal -> Goal
updateGoal (NextLevel nl) = NextLevel $ nl { sprite = incrementFrame nl.sprite }
updateGoal (GunPickup gp) = GunPickup $ updateGun gp

isGunGoal :: Goal -> Boolean
isGunGoal (NextLevel _) = false
isGunGoal (GunPickup _) = true

isNextLevelGoal :: Goal -> Boolean
isNextLevelGoal (NextLevel _) = true
isNextLevelGoal (GunPickup _) = false

mapToGun :: Goal -> Maybe Gun
mapToGun (NextLevel _) = Nothing
mapToGun (GunPickup gp) = Just gp

firstGun :: Array Goal -> Maybe Gun
firstGun goals = head guns
    where 
        guns = mapMaybe mapToGun goals
