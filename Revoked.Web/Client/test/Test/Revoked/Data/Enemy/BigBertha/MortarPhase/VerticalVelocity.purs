module Test.Revoked.Data.Enemy.BigBertha.MortarPhase.VerticalVelocity ( 
    verticalVelocityTests 
) where

import Data.Enemy.BigBertha.MortarPhase (verticalVelocity)
import Test.Unit (TestSuite, suite, test)
import Test.Helper (equalTolerance)

verticalVelocityTests :: TestSuite
verticalVelocityTests =
    suite "Revoked.Data.Enemy.BigBertha.MortarPhase - verticalVelocity" do
        test "shouldHaveExpectedValue" do
            let 
                expected = 19.5959

                result = verticalVelocity
            equalTolerance expected result