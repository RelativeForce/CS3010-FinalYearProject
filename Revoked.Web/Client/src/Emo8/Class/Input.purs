module Emo8.Class.Input where

import Effect (Effect)
import Signal (Signal)

-- | The class definition for user input which can be polled.
class Input a where

  -- | Poll the user input into the instance type.
  poll :: Effect (Signal a) 
