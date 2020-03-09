module Test.Engine.Emo8.Data.Sprite( 
    spriteTests 
) where

import Prelude

import Test.Unit (TestSuite)

import Test.Engine.Emo8.Data.Sprite.CurrentFrame (currentFrameTests)
import Test.Engine.Emo8.Data.Sprite.IncrementFrame (incrementFrameTests)
import Test.Engine.Emo8.Data.Sprite.ToScaledImage (toScaledImageTests)

spriteTests :: TestSuite
spriteTests = do
    currentFrameTests
    incrementFrameTests
    toScaledImageTests
    
