module Test.Revoked.Helper.AdjustPlayerPos ( 
    adjustPlayerPosTests 
) where

import Prelude
import Data.Player (Player(..), Appear(..))
import Data.Sprites as S
import Helper (adjustPlayerPos)
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)

adjustPlayerPosTests :: TestSuite
adjustPlayerPosTests =
    suite "Helper - adjustPlayerPos" do
        test "shouldAdjustXCorrectlyWhenOffsetIsPositive" do
            let 
                offset = 32
                playerX = 12

                expectedResult = offset + playerX
                (Player result) = adjustPlayerPos (buildPlayer playerX) offset
            equal expectedResult result.pos.x
        test "shouldAdjustXCorrectlyWhenOffsetIsNegative" do
            let 
                offset = 32
                playerX = -24

                expectedResult = offset + playerX
                (Player result) = adjustPlayerPos (buildPlayer playerX) offset
            equal expectedResult result.pos.x

buildPlayer :: Int -> Player
buildPlayer x = Player { 
    pos: { 
        x: x, 
        y: 0
    }, 
    energy: 0, 
    appear: Stable,
    sprite: S.player,
    velocity: {
        xSpeed: 0.0,
        ySpeed: 0.0
    },
    onFloor: true
}