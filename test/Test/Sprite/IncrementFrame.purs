module Test.Sprite.IncrementFrame ( 
    incrementFrameTests 
) where

import Prelude

import Emo8.Types (Sprite)
import Emo8.Data.Sprite (incrementFrame)
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)

incrementFrameTests :: TestSuite
incrementFrameTests =
    suite "Sprite - incrementFrame" do
        test "shouldIncrementFrameWhenSpriteIsValid [1 10]" do
            let 
                result = incrementFrame $ buildSprite 0 10
                expectedFrame = 1
            equal expectedFrame result.currentFrame 
        test "shouldIncrementFrameWhenSpriteIsValid [5 10]" do
            let 
                result = incrementFrame $ buildSprite 5 10
                expectedFrame = 6
            equal expectedFrame result.currentFrame 
        test "shouldIncrementFrameWhenSpriteIsValid [9 10]" do
            let 
                result = incrementFrame $ buildSprite 9 10
                expectedFrame = 0
            equal expectedFrame result.currentFrame 

buildSprite :: Int -> Int -> Sprite
buildSprite current frameCount = {
    frameFolder: "test",
    currentFrame: current,
    frameCount: frameCount,
    width: 100,
    height: 100,
    extension: "png"
}