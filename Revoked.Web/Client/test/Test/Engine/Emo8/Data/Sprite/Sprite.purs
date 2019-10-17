module Test.Engine.Emo8.Data.Sprite( 
    spriteTests 
) where

import Prelude

import Effect (Effect)
import Test.Engine.Emo8.Data.Sprite.CurrentFrame (currentFrameTests)
import Test.Engine.Emo8.Data.Sprite.IncrementFrame (incrementFrameTests)
import Test.Engine.Emo8.Data.Sprite.ToScaledImage (toScaledImageTests)
import Test.Unit.Main (runTest)

spriteTests :: Effect Unit
spriteTests = do
    -- Sub Modules
    runTest do
        currentFrameTests
        incrementFrameTests
        toScaledImageTests
    -- Tests
