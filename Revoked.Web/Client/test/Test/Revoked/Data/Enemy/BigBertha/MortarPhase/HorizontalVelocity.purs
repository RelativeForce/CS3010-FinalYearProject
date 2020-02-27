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
        test "assert speed = 0.0 when target(x: 0, y: 0), mortar(x: 0, y: 0)" do
            let 
                target = { x: 0, y: 0}
                mortar = { x: 0, y: 0}
                expected = 0.0

                result = horizontalVelocity target mortar
            equalTolerance expected result
        test "assert speed = -1.2757 when target(x: 0, y: 0), mortar(x: 100, y: 0)" do
            let 
                target = { x: 0, y: 0}
                mortar = { x: 100, y: 0}
                expected = -1.2757

                result = horizontalVelocity target mortar
            equalTolerance expected result
        test "assert speed = 1.2757 when target(x: 100, y: 0), mortar(x: 0, y: 0)" do
            let 
                target = { x: 100, y: 0}
                mortar = { x: 0, y: 0}
                expected = 1.2757

                result = horizontalVelocity target mortar
            equalTolerance expected result
        test "assert speed = 0.6378 when target(x: 50, y: 0), mortar(x: 0, y: 0)" do
            let 
                target = { x: 50, y: 0}
                mortar = { x: 0, y: 0}
                expected = 0.6378

                result = horizontalVelocity target mortar
            equalTolerance expected result
        test "assert speed = -0.6378 when target(x: 0, y: 0), mortar(x: 50, y: 0)" do
            let 
                target = { x: 0, y: 0}
                mortar = { x: 50, y: 0}
                expected = -0.6378

                result = horizontalVelocity target mortar
            equalTolerance expected result
        test "assert speed = -1.2367 when target(x: 0, y: 0), mortar(x: 100, y: 50)" do
            let 
                target = { x: 0, y: 0}
                mortar = { x: 100, y: 50}
                expected = -1.2367

                result = horizontalVelocity target mortar
            equalTolerance expected result
        test "assert speed = -1.3202 when target(x: 0, y: 50), mortar(x: 100, y: 0)" do
            let 
                target = { x: 0, y: 50}
                mortar = { x: 100, y: 0}
                expected = -1.3202

                result = horizontalVelocity target mortar
            equalTolerance expected result