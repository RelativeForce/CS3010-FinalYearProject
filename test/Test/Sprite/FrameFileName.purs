module Test.Sprite.FrameFileName ( 
    frameFileNameTests 
) where

import Prelude

import Emo8.Types (Sprite)
import Emo8.Data.Sprite (frameFileName)
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)

frameFileNameTests :: TestSuite
frameFileNameTests =
    suite "Sprite - frameFileName" do
        test "shouldReturnValidFileNameWhenSpriteIsValid [test 1 png]" do
            equal "test\\1.png" $ frameFileName $ buildSpriteForFileName "test" 1 "png"
        test "shouldReturnValidFileNameWhenSpriteIsValid [test 1 bmp]" do
            equal "test\\1.bmp" $ frameFileName $ buildSpriteForFileName "test" 1 "bmp"
        test "shouldReturnValidFileNameWhenSpriteIsValid [test 5 png]" do
            equal "test\\5.png" $ frameFileName $ buildSpriteForFileName "test" 5 "png"
        test "shouldReturnValidFileNameWhenSpriteIsValid [nested\\test 1 png]" do
            equal "nested\\test\\1.png" $ frameFileName $ buildSpriteForFileName "nested\\test" 1 "png"

buildSpriteForFileName :: String -> Int -> String -> Sprite
buildSpriteForFileName folder current extension = {
    frameFolder: folder,
    currentFrame: current,
    frameCount: 10,
    width: 100,
    height: 100,
    extension: extension
}