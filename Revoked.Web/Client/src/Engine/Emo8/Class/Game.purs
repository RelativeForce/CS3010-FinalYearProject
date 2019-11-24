module Emo8.Class.Game where

import Prelude

import Emo8.Action.Draw (Draw)
import Emo8.Action.Update (Update)
import Emo8.Input (Input)
import Emo8.Types (Asset)

-- | Game class.
-- | Methods are called in order update, draw, sound every frame.
class Game s where
  update :: Asset -> Input -> s -> Update s
  draw :: s -> Draw Unit
