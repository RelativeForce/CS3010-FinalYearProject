module Test.Revoked.Collision.AdjustY ( 
    adjustYTests 
) where

import Prelude
import Collision (adjustY)
import Emo8.Types (Height)
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)

adjustYTests :: TestSuite
adjustYTests =
    suite "Collision - adjustY" do

        -- Moving Up
        test "ASSERT y = 64 WHEN oldY = 0, newY = 64" do
            let 
                oldY = 0
                newY = 64

                expectedResult = 64
                result = adjustY oldY newY entityHeight
            equal expectedResult result

        test "ASSERT y = 32 WHEN oldY = 30, newY = 32" do
            let 
                oldY = 30
                newY = 32

                expectedResult = 32
                result = adjustY oldY newY entityHeight
            equal expectedResult result

        test "ASSERT y = 0 WHEN oldY = 4, newY = 7" do
            let 
                oldY = 4
                newY = 7

                expectedResult = 0
                result = adjustY oldY newY entityHeight
            equal expectedResult result

        -- Moving Down
        test "ASSERT y = 32 WHEN oldY = 64, newY = 0" do
            let 
                oldY = 64
                newY = 0

                expectedResult = 32
                result = adjustY oldY newY entityHeight
            equal expectedResult result

        test "ASSERT y = 32 WHEN oldY = 32, newY = 30" do
            let 
                oldY = 32
                newY = 30

                expectedResult = 32
                result = adjustY oldY newY entityHeight
            equal expectedResult result

        test "ASSERT y = 32 WHEN oldY = 7, newY = 4" do
            let 
                oldY = 7
                newY = 4

                expectedResult = 32
                result = adjustY oldY newY entityHeight
            equal expectedResult result

entityHeight :: Height
entityHeight = 32