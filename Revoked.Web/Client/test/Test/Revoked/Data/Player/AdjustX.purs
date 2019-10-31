module Test.Revoked.Data.Player.AdjustX ( 
    adjustXTests 
) where

import Prelude
import Data.Player (adjustX)
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)

adjustXTests :: TestSuite
adjustXTests =
    suite "Player - adjustX" do

        -- Moving Left
        test "shouldReturnCorrectValueWhenMovingLeft [12, 64, 0 -> 20]" do
            let 
                oldY = 64
                newY = 0
                distance = 12

                expectedResult = 20
                result = adjustX oldY newY distance
            equal expectedResult result

        test "shouldReturnCorrectValueWhenMovingLeft [0, 64, 0 -> 32]" do
            let 
                oldY = 64
                newY = 0
                distance = 0

                expectedResult = 32
                result = adjustX oldY newY distance
            equal expectedResult result

        test "shouldReturnCorrectValueWhenMovingLeft [0, 32, 30 -> 32]" do
            let 
                oldY = 32
                newY = 30
                distance = 0

                expectedResult = 32
                result = adjustX oldY newY distance
            equal expectedResult result

        test "shouldReturnCorrectValueWhenMovingLeft [0, 7, 4 -> 32]" do
            let 
                oldY = 7
                newY = 4
                distance = 0

                expectedResult = 32
                result = adjustX oldY newY distance
            equal expectedResult result

        -- Moving Right
        test "shouldReturnCorrectValueWhenMovingRight [12, 0, 64 -> 52]" do
            let 
                oldY = 0
                newY = 64
                distance = 12

                expectedResult = 52
                result = adjustX oldY newY distance
            equal expectedResult result

        test "shouldReturnCorrectValueWhenMovingRight [0, 0, 64 -> 64]" do
            let 
                oldY = 0
                newY = 64
                distance = 0

                expectedResult = 64
                result = adjustX oldY newY distance
            equal expectedResult result

        test "shouldReturnCorrectValueWhenMovingRight [0, 30, 32 -> 32]" do
            let 
                oldY = 30
                newY = 32
                distance = 0

                expectedResult = 32
                result = adjustX oldY newY distance
            equal expectedResult result

        test "shouldReturnCorrectValueWhenMovingRight [0, 4, 7 -> 0]" do
            let 
                oldY = 4
                newY = 7
                distance = 0

                expectedResult = 0
                result = adjustX oldY newY distance
            equal expectedResult result