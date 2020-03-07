module Test.Engine.Emo8.Data.Sprite( 
    spriteTests 
) where

import Prelude

import Test.Engine.Emo8.Data.Sprite.CurrentFrame (currentFrameTests)
import Test.Engine.Emo8.Data.Sprite.IncrementFrame (incrementFrameTests)
import Test.Engine.Emo8.Data.Sprite.ToScaledImage (toScaledImageTests)
import Test.Unit (TestSuite)

spriteTests :: TestSuite
spriteTests = do
    currentFrameTests
    incrementFrameTests
    toScaledImageTests
    
