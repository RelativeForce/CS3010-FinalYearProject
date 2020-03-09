module Test.Revoked.Collision.AdjustX ( 
    adjustXTests 
) where

import Prelude
import Revoked.Collision (adjustX)
import Emo8.Types (Width)
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)

adjustXTests :: TestSuite
adjustXTests =
    suite "Revoked.Collision - adjustX" do

        -- Moving Left
        test "ASSERT x = 20 WHEN oldX = 64, newX = 0, distance = 12" do
            let 
                oldX = 64
                newX = 0
                distance = 12

                expectedResult = 20
                result = adjustX oldX newX distance entityWidth
            equal expectedResult result

        test "ASSERT x = 32 WHEN oldX = 64, newX = 0, distance = 0" do
            let 
                oldX = 64
                newX = 0
                distance = 0

                expectedResult = 32
                result = adjustX oldX newX distance entityWidth
            equal expectedResult result

        test "ASSERT x = 32 WHEN oldX = 32, newX = 30, distance = 0" do
            let 
                oldX = 32
                newX = 30
                distance = 0

                expectedResult = 32
                result = adjustX oldX newX distance entityWidth
            equal expectedResult result

        test "ASSERT x = 32 WHEN oldX = 7, newX = 4, distance = 0" do
            let 
                oldX = 7
                newX = 4
                distance = 0

                expectedResult = 32
                result = adjustX oldX newX distance entityWidth
            equal expectedResult result

        -- Moving Right
        test "ASSERT x = 52 WHEN oldX = 0, newX = 64, distance = 12" do
            let 
                oldX = 0
                newX = 64
                distance = 12

                expectedResult = 52
                result = adjustX oldX newX distance entityWidth
            equal expectedResult result

        test "ASSERT x = 64 WHEN oldX = 0, newX = 64, distance = 0" do
            let 
                oldX = 0
                newX = 64
                distance = 0

                expectedResult = 64
                result = adjustX oldX newX distance entityWidth
            equal expectedResult result

        test "ASSERT x = 32 WHEN oldX = 30, newX = 32, distance = 0" do
            let 
                oldX = 30
                newX = 32
                distance = 0

                expectedResult = 32
                result = adjustX oldX newX distance entityWidth
            equal expectedResult result

        test "ASSERT x = 0 WHEN oldX = 4, newX = 7, distance = 0" do
            let 
                oldX = 4
                newX = 7
                distance = 0

                expectedResult = 0
                result = adjustX oldX newX distance entityWidth
            equal expectedResult result

entityWidth :: Width
entityWidth = 32