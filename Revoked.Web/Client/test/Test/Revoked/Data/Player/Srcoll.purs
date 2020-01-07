module Test.Revoked.Data.Player.Srcoll ( 
    scrollTests 
) where

import Prelude
import Class.Object (scroll)
import Data.Player (Player(..),  initialPlayer)
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)

scrollTests :: TestSuite
scrollTests =
    suite "Revoked.Data.Player - scroll" do
        test "shouldAdjustXCorrectlyWhenOffsetIsPositive" do
            let 
                offset = 32
                playerX = 12

                expectedResult = offset + playerX
                (Player result) = scroll offset (buildPlayer playerX)
            equal expectedResult result.pos.x
        test "shouldAdjustXCorrectlyWhenOffsetIsNegative" do
            let 
                offset = 32
                playerX = -24

                expectedResult = offset + playerX
                (Player result) = scroll offset (buildPlayer playerX)
            equal expectedResult result.pos.x

buildPlayer :: Int -> Player
buildPlayer x = Player $ p { pos = p.pos { x = x } } 
    where
        (Player p) = initialPlayer
  