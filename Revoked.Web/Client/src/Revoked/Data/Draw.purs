module Data.Draw where

import Prelude

import Revoked.Assets.Images as I
import Emo8.Class.Object (position, size)
import Revoked.Class.MortalEntity (class MortalEntity, health)
import Data.Array ((..))
import Data.Traversable (for_)
import Emo8.Action.Draw (Draw, drawScaledImage)
import Emo8.Types (Position)

drawHealth :: forall a. MortalEntity a => a -> Draw Unit
drawHealth entity = do
    for_ (map toHeartPosition indexes) \(heartPos) -> 
        drawScaledImage I.heart heartPos.x heartPos.y
        where 
            entityPos = position entity
            entitySize = size entity
            entityHealth = health entity
            indexes = if entityHealth > 0 then 0 .. (entityHealth - 1) else []
            padding = 5
            increment = I.heart.size.width + padding
            width = increment * entityHealth
            toHeartPosition :: Int -> Position
            toHeartPosition i = { 
                x: entityPos.x - ( width / 2) + (i * increment) + (entitySize.width / 2), 
                y: entityPos.y + entitySize.height + 5
            }