module Test.Sprite( 
    spriteTests 
) where

import Prelude

import Effect (Effect)
import Test.Unit.Main (runTest)
import Test.Sprite.FrameFileName (frameFileNameTests)

spriteTests :: Effect Unit
spriteTests = do
    -- Tests
    runTest do
        frameFileNameTests
    -- Sub Modules
