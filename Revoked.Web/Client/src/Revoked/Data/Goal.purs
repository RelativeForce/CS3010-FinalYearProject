module Data.Goal where

import Class.Object (class ObjectDraw, class Object)
import Emo8.Action.Draw (drawSprite)
import Emo8.Types (Position, Sprite)

data Goal = Goal {
    pos :: Position, 
    sprite :: Sprite 
}

instance objectGoal :: Object Goal where
    size (Goal g) = g.sprite.size
    position (Goal g) = g.pos

instance objectDrawGoal :: ObjectDraw Goal where
    draw (Goal g) = drawSprite g.sprite g.pos.x g.pos.y