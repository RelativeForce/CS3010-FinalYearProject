module Emo8.Class.Object where
  
import Prelude

import Emo8.Action.Draw (Draw)
import Emo8.Types (Size, Position)
  
-- | The class definition for any object that can exist in the game 
-- | space. Any instance type of this can be used in collision and 
-- | other physics based functionality.
class Object s where

    -- | Retrives the `Size` of the instance type.
    size :: s -> Size

    -- | Retrives the `Position` of the instance type.
    position :: s -> Position

    -- | Moves the instance type's `Position` horizontally by the specified number 
    -- | of pixels
    scroll :: Int -> s -> s

-- | The class definition for any object that can be drawn on screen.
-- | Derived from `Object`
class Object s <= ObjectDraw s where

    -- | Draws the instance type on screen.
    draw :: s -> Draw Unit