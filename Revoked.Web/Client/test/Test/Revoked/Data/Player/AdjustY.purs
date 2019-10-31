module Test.Revoked.Data.Player.AdjustY ( 
    adjustYTests 
) where

import Prelude
import Data.Player (adjustY)
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)

adjustYTests :: TestSuite
adjustYTests =
    suite "Player - adjustY" do
        test "shouldReturnCorrectValueWhenMovingUp [0 -> 64]" do
            let 
                oldY = 0
                newY = 64

                expectedResult = 64
                result = adjustY oldY newY
            equal expectedResult result

        test "shouldReturnCorrectValueWhenMovingUp [30 -> 32]" do
            let 
                oldY = 30
                newY = 32

                expectedResult = 32
                result = adjustY oldY newY
            equal expectedResult result

        test "shouldReturnCorrectValueWhenMovingUp [4 -> 7]" do
            let 
                oldY = 4
                newY = 7

                expectedResult = 0
                result = adjustY oldY newY
            equal expectedResult result