module Test.Revoked.Collision.AdjustX ( 
    adjustXTests 
) where

import Prelude
import Collision (adjustX)
import Emo8.Types (Width)
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)

adjustXTests :: TestSuite
adjustXTests =
    suite "Collision - adjustX" do

        -- Moving Left
        test "shouldAdjustXCorrectlyWhenMovingLeft [12, 64, 0 -> 20]" do
            let 
                oldX = 64
                newX = 0
                distance = 12

                expectedResult = 20
                result = adjustX oldX newX distance entityWidth
            equal expectedResult result

        test "shouldAdjustXCorrectlyWhenMovingLeft [0, 64, 0 -> 32]" do
            let 
                oldX = 64
                newX = 0
                distance = 0

                expectedResult = 32
                result = adjustX oldX newX distance entityWidth
            equal expectedResult result

        test "shouldAdjustXCorrectlyWhenMovingLeft [0, 32, 30 -> 32]" do
            let 
                oldX = 32
                newX = 30
                distance = 0

                expectedResult = 32
                result = adjustX oldX newX distance entityWidth
            equal expectedResult result

        test "shouldAdjustXCorrectlyWhenMovingLeft [0, 7, 4 -> 32]" do
            let 
                oldX = 7
                newX = 4
                distance = 0

                expectedResult = 32
                result = adjustX oldX newX distance entityWidth
            equal expectedResult result

        -- Moving Right
        test "shouldAdjustXCorrectlyWhenMovingRight [12, 0, 64 -> 52]" do
            let 
                oldX = 0
                newX = 64
                distance = 12

                expectedResult = 52
                result = adjustX oldX newX distance entityWidth
            equal expectedResult result

        test "shouldAdjustXCorrectlyWhenMovingRight [0, 0, 64 -> 64]" do
            let 
                oldX = 0
                newX = 64
                distance = 0

                expectedResult = 64
                result = adjustX oldX newX distance entityWidth
            equal expectedResult result

        test "shouldAdjustXCorrectlyWhenMovingRight [0, 30, 32 -> 32]" do
            let 
                oldX = 30
                newX = 32
                distance = 0

                expectedResult = 32
                result = adjustX oldX newX distance entityWidth
            equal expectedResult result

        test "shouldAdjustXCorrectlyWhenMovingRight [0, 4, 7 -> 0]" do
            let 
                oldX = 4
                newX = 7
                distance = 0

                expectedResult = 0
                result = adjustX oldX newX distance entityWidth
            equal expectedResult result

entityWidth :: Width
entityWidth = 32