module Test.Engine.Emo8.Data.Sprite.ToScaledImage ( 
    toScaledImageTests 
) where

import Prelude

import Emo8.Types (Sprite)
import Emo8.Data.Sprite (toScaledImage)
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)

toScaledImageTests :: TestSuite
toScaledImageTests =
    suite "Sprite - toScaledImage" do
        test "shouldConvertToScaledImageWhenSpriteIsValid [387 457]" do
            let 
                expectedWidth = 387
                expectedHeight = 457
                expectedFrame = "frame1"
                result = toScaledImage $ buildSprite expectedWidth expectedHeight   
            equal expectedFrame result.image
            equal expectedWidth result.width 
            equal expectedHeight result.height
        test "shouldConvertToScaledImageWhenSpriteIsValid [32423 453453]" do
            let 
                expectedWidth = 32423
                expectedHeight = 453453
                expectedFrame = "frame1"
                result = toScaledImage $ buildSprite expectedWidth expectedHeight   
            equal expectedFrame result.image
            equal expectedWidth result.width 
            equal expectedHeight result.height   

buildSprite :: Int -> Int -> Sprite
buildSprite width height = {
    frames: ["frame0", "frame1", "frame2", "frame3", "frame4", "frame5", "frame6", "frame7", "frame8", "frame9"],
    frameCount: 10,
    frameIndex: 1,
    framesPerSecond: 1,
    width: width,
    height: height
}