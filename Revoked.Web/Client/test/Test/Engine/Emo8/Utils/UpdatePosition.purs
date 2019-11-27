module Test.Engine.Emo8.Utils.UpdatePosition ( 
    updatePositionTests 
) where

import Prelude
import Emo8.Utils (updatePosition)
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)

updatePositionTests :: TestSuite
updatePositionTests =
    suite "Emo8.Utils - updatePosition" do
        test "shouldSumXSpeedAndXPosition" do
            let 
                velocity = { xSpeed: 5.0, ySpeed: 3.0 }
                position = { x: 5, y: 3 }

                result = updatePosition position velocity
            equal 10 result.x
            equal 6 result.y