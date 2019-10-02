module Test.Sprite ( 
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
        test "checkValid [test 1 png]" do
            equal "test\\1.png" $ frameFileName $ buildSpriteForFileName "test" 1 "png"

buildSpriteForFileName :: String -> Int -> String -> Sprite
buildSpriteForFileName folder current extension = {
    frameFolder: folder,
    currentFrame: current,
    frameCount: 10,
    width: 100,
    height: 100,
    extension: extension
}