module Test.Engine.Emo8.Data ( 
    dataTests 
) where

import Prelude

import Effect (Effect)
import Test.Engine.Emo8.Data.Sprite (spriteTests)

dataTests :: Effect Unit
dataTests = do
    -- Tests

    -- Sub Modules
    spriteTests
