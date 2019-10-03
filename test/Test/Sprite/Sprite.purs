module Test.Sprite( 
    spriteTests 
) where

import Prelude

import Effect (Effect)
import Test.Sprite.FrameFileName (frameFileNameTests)
import Test.Sprite.IncrementFrame (incrementFrameTests)
import Test.Unit.Main (runTest)

spriteTests :: Effect Unit
spriteTests = do
    -- Tests
    runTest do
        frameFileNameTests
        incrementFrameTests
    -- Sub Modules
