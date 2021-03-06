module Test.Revoked.Data.Enemy.BigBertha.MortarPhase.VerticalVelocity ( 
    verticalVelocityTests 
) where

import Test.Unit (TestSuite, suite, test)
import Test.Helper (equalTolerance)

import Revoked.Data.Enemy.BigBertha.MortarPhase (verticalVelocity)

verticalVelocityTests :: TestSuite
verticalVelocityTests =
    suite "Revoked.Data.Enemy.BigBertha.MortarPhase - verticalVelocity" do
        test "SHOULD have expected value" do
            let 
                expected = 19.5959

                result = verticalVelocity
            equalTolerance expected result