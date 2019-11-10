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
    scroll offset (Goal s) = Goal $ s { pos = { x: s.pos.x + offset, y: s.pos.y }}

instance objectDrawGoal :: ObjectDraw Goal where
    draw (Goal g) = drawSprite g.sprite g.pos.x g.pos.y

updateGoal :: Goal -> Goal
updateGoal (Goal g) = Goal $ g { 
    sprite = incrementFrame g.sprite
}