module Test.Sprite.CurrentFrame ( 
    currentFrameTests 
) where

import Prelude

import Emo8.Types (Sprite)
import Emo8.Data.Sprite (currentFrame)
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)

currentFrameTests :: TestSuite
currentFrameTests =
    suite "Sprite - currentFrame" do
        test "shouldReturnFrame0WhenSpriteIsOnIndex1" do
            equal "frame0" $ currentFrame $ buildSprite 1
        test "shouldReturnFrame1WhenSpriteIsOnIndex2" do
            equal "frame1" $ currentFrame $ buildSprite 2
        test "shouldReturnFrame5WhenSpriteIsOnIndex10" do
            equal "frame5" $ currentFrame $ buildSprite 10
        test "shouldReturnFrame8WhenSpriteIsOnIndex17" do
            equal "frame8" $ currentFrame $ buildSprite 17

buildSprite :: Int -> Sprite
buildSprite current = {
    frames: ["frame0", "frame1", "frame2", "frame3", "frame4", "frame5", "frame6", "frame7", "frame8", "frame9"],
    frameCount: 10,
    frameIndex: current,
    framesPerSecond: 2,
    width: 100,
    height: 100
}