module Test.Emo8.Data.Sprite( 
    spriteTests 
) where

import Prelude

import Test.Unit (TestSuite)

import Test.Emo8.Data.Sprite.CurrentFrame (currentFrameTests)
import Test.Emo8.Data.Sprite.IncrementFrame (incrementFrameTests)
import Test.Emo8.Data.Sprite.ToScaledImage (toScaledImageTests)

spriteTests :: TestSuite
spriteTests = do
    currentFrameTests
    incrementFrameTests
    toScaledImageTests
    
