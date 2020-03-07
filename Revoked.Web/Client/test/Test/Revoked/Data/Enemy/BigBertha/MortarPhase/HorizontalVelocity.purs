module Test.Revoked.Data.Enemy.BigBertha.MortarPhase.HorizontalVelocity ( 
    horizontalVelocityTests 
) where

import Prelude
import Data.Enemy.BigBertha.MortarPhase (horizontalVelocity)
import Test.Unit (TestSuite, suite, test)
import Test.Helper (equalTolerance)

horizontalVelocityTests :: TestSuite
horizontalVelocityTests =
    suite "Revoked.Data.Enemy.BigBertha.MortarPhase - horizontalVelocity" do
        test "ASSERT velocity = 0.0 WHEN target x = 0 AND target y = 0 AND mortar x = 0 AND mortar y = 0" do
            let 
                target = { x: 0, y: 0 }
                mortar = { x: 0, y: 0 }
                expected = 0.0

                result = horizontalVelocity target mortar
            equalTolerance expected result
        test "ASSERT velocity = -1.2757 WHEN target x = 0 AND target y = 0 AND mortar x = 100 AND mortar y = 0" do
            let 
                target = { x: 0, y: 0 }
                mortar = { x: 100, y: 0 }
                expected = -1.2757

                result = horizontalVelocity target mortar
            equalTolerance expected result
        test "ASSERT velocity = 1.2757 WHEN target x = 100 AND target y = 0 AND mortar x = 0 AND mortar y = 0" do
            let 
                target = { x: 100, y: 0 }
                mortar = { x: 0, y: 0 }
                expected = 1.2757

                result = horizontalVelocity target mortar
            equalTolerance expected result
        test "ASSERT velocity = 0.6378 WHEN target x = 50 AND target y = 0 AND mortar x = 0 AND mortar y = 0" do
            let 
                target = { x: 50, y: 0 }
                mortar = { x: 0, y: 0 }
                expected = 0.6378

                result = horizontalVelocity target mortar
            equalTolerance expected result
        test "ASSERT velocity = -0.6378 WHEN target x = 0 AND target y = 0 AND mortar x = 50 AND mortar y = 0" do
            let 
                target = { x: 0, y: 0 }
                mortar = { x: 50, y: 0 }
                expected = -0.6378

                result = horizontalVelocity target mortar
            equalTolerance expected result
        test "ASSERT velocity = -1.2367 WHEN target x = 0 AND target y = 0 AND mortar x = 100 AND mortar y = 50" do
            let 
                target = { x: 0, y: 0 }
                mortar = { x: 100, y: 50 }
                expected = -1.2367

                result = horizontalVelocity target mortar
            equalTolerance expected result
        test "ASSERT velocity = -1.3202 WHEN target x = 0 AND target y = 50 AND mortar x = 100 AND mortar y = 0" do
            let 
                target = { x: 0, y: 50}
                mortar = { x: 100, y: 0}
                expected = -1.3202

                result = horizontalVelocity target mortar
            equalTolerance expected result