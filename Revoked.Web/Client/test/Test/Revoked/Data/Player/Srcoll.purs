module Test.Revoked.Data.Player.Srcoll ( 
    scrollTests 
) where

import Prelude
import Emo8.Class.Object (scroll)
import Data.Player (Player(..),  initialPlayer)
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)

scrollTests :: TestSuite
scrollTests =
    suite "Revoked.Data.Player - scroll" do
        test "SHOULD adjust X to 44 WHEN offset is 32 AND player x is 12" do
            let 
                offset = 32
                playerX = 12

                expectedResult = offset + playerX
                (Player result) = scroll offset (buildPlayer playerX)
            equal expectedResult result.pos.x
        test "SHOULD adjust X to 8 WHEN offset is -32 AND player x is 24" do
            let 
                offset = -32
                playerX = 24

                expectedResult = offset + playerX
                (Player result) = scroll offset (buildPlayer playerX)
            equal expectedResult result.pos.x

buildPlayer :: Int -> Player
buildPlayer x = initialPlayer { x: x, y: 0 }
  