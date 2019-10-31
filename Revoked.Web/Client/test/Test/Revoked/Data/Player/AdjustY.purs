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

        -- Moving Up
        test "shouldReturnCorrectValueWhenMovingUp [0, 64 -> 64]" do
            let 
                oldY = 0
                newY = 64

                expectedResult = 64
                result = adjustY oldY newY
            equal expectedResult result

        test "shouldReturnCorrectValueWhenMovingUp [30, 32 -> 32]" do
            let 
                oldY = 30
                newY = 32

                expectedResult = 32
                result = adjustY oldY newY
            equal expectedResult result

        test "shouldReturnCorrectValueWhenMovingUp [4, 7 -> 0]" do
            let 
                oldY = 4
                newY = 7

                expectedResult = 0
                result = adjustY oldY newY
            equal expectedResult result

        -- Moving Down
        test "shouldReturnCorrectValueWhenMovingDown [64, 0 -> 64]" do
            let 
                oldY = 64
                newY = 0

                expectedResult = 32
                result = adjustY oldY newY
            equal expectedResult result

        test "shouldReturnCorrectValueWhenMovingDown [32, 30 -> 32]" do
            let 
                oldY = 32
                newY = 30

                expectedResult = 32
                result = adjustY oldY newY
            equal expectedResult result

        test "shouldReturnCorrectValueWhenMovingUp [7, 4 -> 0]" do
            let 
                oldY = 7
                newY = 4

                expectedResult = 32
                result = adjustY oldY newY
            equal expectedResult result