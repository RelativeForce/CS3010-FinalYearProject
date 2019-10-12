module Test.Sprite( 
    spriteTests 
) where

import Prelude

import Effect (Effect)
import Test.Sprite.CurrentFrame (currentFrameTests)
import Test.Sprite.IncrementFrame (incrementFrameTests)
import Test.Sprite.ToScaledImage (toScaledImageTests)
import Test.Unit.Main (runTest)

spriteTests :: Effect Unit
spriteTests = do
    -- Tests
    runTest do
        currentFrameTests
        incrementFrameTests
        toScaledImageTests
    -- Sub Modules
