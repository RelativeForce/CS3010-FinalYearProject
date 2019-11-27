module Test.Revoked.Data.Player.Srcoll ( 
    scrollTests 
) where

import Prelude
import Class.Object (scroll)
import Data.Player (Player(..), Appear(..))
import Assets.Sprites as S
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