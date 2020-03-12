module Emo8.Class.Game where

import Prelude

import Emo8.Action.Draw (Draw)
import Emo8.Action.Update (Update)
import Emo8.Input (Input)
import Emo8.Types (Asset)

-- | The class definition for the state of the game that can be drawn and 
-- | updated. Each frame the game state is updated then drawn.
class Game s where

  -- | Updates the specified Game state using the given `Asset` and the 
  -- | user `Input` into the next state which is contained in the 
  -- | `Update` monad. This must be interpreted in order to access the new 
  -- | state as the new state is dependent on the evaluation of non-pure 
  -- | functions.
  update :: Asset -> Input -> s -> Update s

  -- | Draws the game state.
  draw :: s -> Draw Unit
