module Test.Revoked.Data.Player.UpdatePosition ( 
    updatePositionTests 
) where

import Prelude
import Emo8.Input (Input)
import Data.Player (updatePosition)
import Test.Unit (TestSuite, suite, test)
import Constants (gravity, frictionFactor, maxPlayerSpeedY, maxPlayerSpeedX)
import Test.Unit.Assert (equal)

updatePositionTests :: TestSuite
updatePositionTests =
    suite "Player - updatePosition" do
        test "shouldSumXSpeedAndXPosition" do
            let 
                velocity = { xSpeed: 5.0, ySpeed: 3.0 }
                position = { x: 5, y: 3 }

                result = updatePosition position velocity
            equal 10 result.x
            equal 6 result.y