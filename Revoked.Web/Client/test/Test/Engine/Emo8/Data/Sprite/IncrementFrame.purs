module Test.Engine.Emo8.Data.Sprite.IncrementFrame ( 
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
        test "shouldIncrementFrameWhenFrameIndexIsWithinFrameLimit [0 10 1]" do
            let 
                result = incrementFrame $ buildSprite 0 10 1
                expectedFrame = 1
            equal expectedFrame result.frameIndex 
        test "shouldIncrementFrameWhenFrameIndexIsWithinFrameLimit [5 10 3]" do
            let 
                result = incrementFrame $ buildSprite 5 10 3
                expectedFrame = 6
            equal expectedFrame result.frameIndex 
        test "shouldResetFrameIndexWhenFrameIndexIsAtFrameLimit [39 10 4]" do
            let 
                result = incrementFrame $ buildSprite 39 10 4
                expectedFrame = 0
            equal expectedFrame result.frameIndex 

buildSprite :: Int -> Int -> Int -> Sprite
buildSprite current frameCount framesPerSecond = {
    frames: ["frame0", "frame1", "frame2", "frame3", "frame4", "frame5", "frame6", "frame7", "frame8", "frame9"],
    frameIndex: current,
    framesPerSecond: framesPerSecond,
    frameCount: frameCount,
    size: {
        width: 100,
        height: 100
    },
    id: 1
}