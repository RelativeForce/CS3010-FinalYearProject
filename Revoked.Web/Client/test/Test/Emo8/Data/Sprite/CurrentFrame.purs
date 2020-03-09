module Test.Emo8.Data.Sprite.CurrentFrame ( 
    currentFrameTests 
) where

import Prelude

import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)

import Emo8.Types (Sprite)
import Emo8.Data.Sprite (currentFrame)

currentFrameTests :: TestSuite
currentFrameTests =
    suite "Emo8.Data.Sprite - currentFrame" do
        test "SHOULD return frame 0 WHEN sprite is on index 1" do
            equal "frame0" $ currentFrame $ buildSprite 1
        test "SHOULD return frame 1 WHEN sprite is on index 2" do
            equal "frame1" $ currentFrame $ buildSprite 2
        test "SHOULD return frame 5 WHEN sprite is on index 10" do
            equal "frame5" $ currentFrame $ buildSprite 10
        test "SHOULD return frame 8 WHEN sprite is on index 17" do
            equal "frame8" $ currentFrame $ buildSprite 17

buildSprite :: Int -> Sprite
buildSprite current = {
    frames: ["frame0", "frame1", "frame2", "frame3", "frame4", "frame5", "frame6", "frame7", "frame8", "frame9"],
    frameCount: 10,
    frameIndex: current,
    framesPerSecond: 2,
    size: {
        width: 100,
        height: 100
    },
    id: 1
}