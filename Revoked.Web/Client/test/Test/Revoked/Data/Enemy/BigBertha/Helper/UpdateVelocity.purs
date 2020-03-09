module Test.Revoked.Data.Enemy.BigBertha.Helper.UpdateVelocity ( 
    updateVelocityTests 
) where

import Prelude

import Revoked.Data.Enemy.BigBertha.Helper (updateVelocity)
import Revoked.Constants (bigBerthaSpeed)
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)

updateVelocityTests :: TestSuite
updateVelocityTests =
    suite "Revoked.Data.Enemy.BigBertha.Helper - updateVelocity" do
        test "SHOULD maintain velocity WHEN not near left or right limit" do
            let 
                distance = 0
                leftLimit = { x: 0, y: 0 }
                rightLimit = { x: 1000, y: 0 }
                pos = { x: 100, y: 0 }
                velocity = { xSpeed: -bigBerthaSpeed, ySpeed: 0.0 }

                expected = { xSpeed: -bigBerthaSpeed, ySpeed: 0.0 }

                result = updateVelocity distance leftLimit rightLimit pos velocity
            equal expected result
        test "SHOULD be zero WHEN moving at current velocity would go past left limit" do
            let 
                distance = 0
                leftLimit = { x: 0, y: 0 }
                rightLimit = { x: 1000, y: 0 }
                pos = { x: 1, y: 0 }
                velocity = { xSpeed: -bigBerthaSpeed, ySpeed: 0.0 }

                expected = { xSpeed: 0.0, ySpeed: 0.0 }

                result = updateVelocity distance leftLimit rightLimit pos velocity
            equal expected result
        test "SHOULD reverse velocity WHEN moving at currentvelocity would go past right limit" do
            let 
                distance = 0
                leftLimit = { x: 0, y: 0 }
                rightLimit = { x: 1000, y: 0 }
                pos = { x: 999, y: 0 }
                velocity = { xSpeed: bigBerthaSpeed, ySpeed: 0.0 }

                expected = { xSpeed: -bigBerthaSpeed, ySpeed: 0.0 }

                result = updateVelocity distance leftLimit rightLimit pos velocity
            equal expected result
