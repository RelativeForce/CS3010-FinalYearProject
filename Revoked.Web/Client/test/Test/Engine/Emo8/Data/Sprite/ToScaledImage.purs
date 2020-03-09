module Test.Engine.Emo8.Data.Sprite.ToScaledImage ( 
    toScaledImageTests 
) where

import Prelude

import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)

import Emo8.Types (Sprite)
import Emo8.Data.Sprite (toScaledImage)

toScaledImageTests :: TestSuite
toScaledImageTests =
    suite "Engine.Emo8.Data.Sprite - toScaledImage" do
        test "SHOULD convert to ScaledImage correctly WHEN width is 387 AND height is 457 AND id is 5" do
            let 
                expectedWidth = 387
                expectedHeight = 457
                expectedFrame = "frame1"
                expectedId = 5
                result = toScaledImage $ buildSprite expectedWidth expectedHeight expectedId 
            equal expectedFrame result.image
            equal expectedWidth result.size.width 
            equal expectedHeight result.size.height
            equal expectedId result.id
        test "SHOULD convert to ScaledImage correctly WHEN width is 32423 AND height is 453453 AND id is 7" do
            let 
                expectedWidth = 32423
                expectedHeight = 453453
                expectedFrame = "frame1"
                expectedId = 8
                result = toScaledImage $ buildSprite expectedWidth expectedHeight expectedId  
            equal expectedFrame result.image
            equal expectedWidth result.size.width 
            equal expectedHeight result.size.height
            equal expectedId result.id   

buildSprite :: Int -> Int -> Int -> Sprite
buildSprite width height id = {
    frames: ["frame0", "frame1", "frame2", "frame3", "frame4", "frame5", "frame6", "frame7", "frame8", "frame9"],
    frameCount: 10,
    frameIndex: 1,
    framesPerSecond: 1,
    size: {
        width: width,
        height: height
    },
    id: id
}