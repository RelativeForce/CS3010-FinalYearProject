module Test.Revoked.Data.Player.UpdateVelocity ( 
    updateVelocityTests 
) where

import Prelude
import Emo8.Input (Input)
import Data.Player (updateVelocity)
import Test.Unit (TestSuite, suite, test)
import Constants (gravity, frictionFactor)
import Test.Unit.Assert (equal)

updateVelocityTests :: TestSuite
updateVelocityTests =
    suite "Player - updateVelocity" do
        test "shouldApplyGravityWhenNotOnFloor" do
            let 
                initialXSpeed = 0.0
                initialYSpeed = 0.0
                velocity = { xSpeed: initialXSpeed, ySpeed: initialYSpeed }
                onFloor = false
                pressingJumpButton = false
                input = buildInput pressingJumpButton

                result = updateVelocity input velocity onFloor
            equal initialXSpeed result.xSpeed
            equal (initialYSpeed + gravity) result.ySpeed
        test "shouldNotApplyGravityWhenOnFloor" do
            let 
                initialXSpeed = 0.0
                still = 0.0
                velocity = { xSpeed: initialXSpeed, ySpeed: still }
                onFloor = true
                pressingJumpButton = false
                input = buildInput pressingJumpButton

                result = updateVelocity input velocity onFloor
            equal initialXSpeed result.xSpeed
            equal still result.ySpeed

buildInput :: Boolean -> Input
buildInput pressingJumpButton = { 
    isLeft: false, 
    isRight: false, 
    isUp: false, 
    isDown: false, 
    isW: false, 
    isA: false, 
    isS: false, 
    isD: false, 
    isSpace: false,
    catched: { 
      isLeft: false, 
      isRight: false, 
      isUp: false, 
      isDown: false, 
      isW: false, 
      isA: false, 
      isS: false, 
      isD: false,
      isSpace: false
    }, 
    released: { 
      isLeft: false, 
      isRight: false, 
      isUp: false, 
      isDown: false, 
      isW: false, 
      isA: false, 
      isS: false, 
      isD: false,
      isSpace: false
    }
}