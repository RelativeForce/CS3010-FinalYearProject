module Data.Goal where

import Prelude
import Class.Object (class ObjectDraw, class Object)
import Emo8.Action.Draw (drawSprite)
import Emo8.Types (Position, Sprite)
import Emo8.Data.Sprite (incrementFrame)

data Goal = Goal {
    pos :: Position, 
    sprite :: Sprite 
}

instance objectGoal :: Object Goal where
    size (Goal g) = g.sprite.size
    position (Goal g) = g.pos

instance objectDrawGoal :: ObjectDraw Goal where
    draw (Goal g) = drawSprite g.sprite g.pos.x g.pos.y

updateGoal :: Int -> Goal -> Goal
updateGoal scrollOffset (Goal g) = Goal $ g { 
    sprite = incrementFrame g.sprite,
    pos = g.pos { x = g.pos.x + scrollOffset }
}