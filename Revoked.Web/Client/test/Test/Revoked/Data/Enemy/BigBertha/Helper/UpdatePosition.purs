module Test.Revoked.Data.Enemy.BigBertha.Helper.UpdatePosition ( 
    updatePositionTests 
) where

import Prelude

import Data.Enemy.BigBertha.Helper (updatePosition)
import Data.Int (floor)
import Revoked.Constants (bigBerthaSpeed)
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)

updatePositionTests :: TestSuite
updatePositionTests =
    suite "Revoked.Data.Enemy.BigBertha.Helper - updatePosition" do
        test "SHOULD move to left WHEN not near left or right limit" do
            let 
                distance = 0
                leftLimit = { x: 0, y: 0 }
                rightLimit = { x: 1000, y: 0 }
                pos = { x: 100, y: 0 }
                velocity = { xSpeed: -bigBerthaSpeed, ySpeed: 0.0 }

                expected = { x: floor (100.0 - bigBerthaSpeed), y: 0 }

                result = updatePosition distance leftLimit rightLimit pos velocity
            equal expected result
        test "SHOULD move to left limit WHEN moving at velocity would go past it" do
            let 
                distance = 0
                leftLimit = { x: 0, y: 0 }
                rightLimit = { x: 1000, y: 0 }
                pos = { x: 1, y: 0 }
                velocity = { xSpeed: -bigBerthaSpeed, ySpeed: 0.0 }

                expected = leftLimit

                result = updatePosition distance leftLimit rightLimit pos velocity
            equal expected result
        test "SHOULD move to right limit WHEN moving at velocity would go past it" do
            let 
                distance = 0
                leftLimit = { x: 0, y: 0 }
                rightLimit = { x: 1000, y: 0 }
                pos = { x: 999, y: 0 }
                velocity = { xSpeed: bigBerthaSpeed, ySpeed: 0.0 }

                expected = rightLimit

                result = updatePosition distance leftLimit rightLimit pos velocity
            equal expected result
