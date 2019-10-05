module Test.Sprite.ToScaledImage ( 
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
                expectedFileName = "test\\1.png"
                result = toScaledImage $ buildSprite expectedWidth expectedHeight   
            equal expectedFileName result.image
            equal expectedWidth result.width 
            equal expectedHeight result.height
        test "shouldConvertToScaledImageWhenSpriteIsValid [32423 453453]" do
            let 
                expectedWidth = 32423
                expectedHeight = 453453
                expectedFileName = "test\\1.png"
                result = toScaledImage $ buildSprite expectedWidth expectedHeight   
            equal expectedFileName result.image
            equal expectedWidth result.width 
            equal expectedHeight result.height   

buildSprite :: Int -> Int -> Sprite
buildSprite width height = {
    folderPath: "test",
    frameCount: 10,
    frameIndex: 1,
    framesPerSecond: 1,
    width: width,
    height: height,
    extension: "png"
}