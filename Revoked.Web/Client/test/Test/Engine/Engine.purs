module Test.Engine ( 
    engineTests 
) where

import Prelude

import Effect (Effect)
import Test.Engine.Emo8 (emo8Tests)

engineTests :: Effect Unit
engineTests = do
    -- Tests

    -- Sub Modules
    emo8Tests
