module Test.Revoked.Data.Player.UpdateVelocity ( 
    updateVelocityTests 
) where

import Prelude
import Emo8.Input (Input)
import Data.Player (updateVelocity)
import Test.Unit (TestSuite, suite, test)
import Constants (gravity, frictionFactor, maxPlayerSpeedY, maxPlayerSpeedX)
import Test.Unit.Assert (equal)

updateVelocityTests :: TestSuite
updateVelocityTests =
    suite "Revoked.Data.Player - updateVelocity" do
        test "shouldApplyGravityWhenNotOnFloor" do
            let 
                velocity = { xSpeed: still, ySpeed: still }
                onFloor = false
                pressingJumpButton = false
                input = buildInput pressingJumpButton false false

                result = updateVelocity input velocity onFloor
            equal still result.xSpeed
            equal (still + gravity) result.ySpeed
        test "shouldNotApplyGravityWhenOnFloor" do
            let 
                velocity = { xSpeed: still, ySpeed: still }
                onFloor = true
                pressingJumpButton = false
                input = buildInput pressingJumpButton false false

                result = updateVelocity input velocity onFloor
            equal still result.xSpeed
            equal still result.ySpeed
        test "shouldJumpWhenOnFloorAndPressingJumpButton" do
            let 
                velocity = { xSpeed: still, ySpeed: still }
                onFloor = true
                pressingJumpButton = true
                input = buildInput pressingJumpButton false false

                result = updateVelocity input velocity onFloor
            equal still result.xSpeed
            equal maxPlayerSpeedY result.ySpeed
        test "shouldNotExceedMaxPlayerSpeedYWhenFalling" do
            let 
                velocity = { xSpeed: still, ySpeed: -maxPlayerSpeedY }
                onFloor = false
                pressingJumpButton = false
                input = buildInput pressingJumpButton false false

                result = updateVelocity input velocity onFloor
            equal still result.xSpeed
            equal (-maxPlayerSpeedY) result.ySpeed
        test "shouldApplyFrictionWhenMovingHorizontally" do
            let 
                velocity = { xSpeed: 1.0, ySpeed: still }
                onFloor = true
                input = buildInput false false false

                result = updateVelocity input velocity onFloor
            equal frictionFactor result.xSpeed
            equal still result.ySpeed
        test "shouldSetMaxSpeedXWhenPressingLeftButton" do
            let 
                velocity = { xSpeed: still, ySpeed: still }
                onFloor = true
                pressingLeftButton = true
                input = buildInput false pressingLeftButton false

                result = updateVelocity input velocity onFloor
            equal (-maxPlayerSpeedX) result.xSpeed
            equal still result.ySpeed
        test "shouldSetMaxSpeedXWhenPressingRightButton" do
            let 
                velocity = { xSpeed: still, ySpeed: still }
                onFloor = true
                pressingRightButton = true
                input = buildInput false false pressingRightButton

                result = updateVelocity input velocity onFloor
            equal maxPlayerSpeedX result.xSpeed
            equal still result.ySpeed

buildInput :: Boolean -> Boolean -> Boolean -> Input
buildInput pressingJumpButton pressingLeftButton pressingRightButton = { 
    isLeft: false, 
    isRight: false, 
    isUp: false, 
    isDown: false, 
    isW: false, 
    isA: pressingLeftButton, 
    isS: false, 
    isD: pressingRightButton, 
    isSpace: pressingJumpButton,
    isEnter: false,
    catched: { 
      isLeft: false, 
      isRight: false, 
      isUp: false, 
      isDown: false, 
      isW: false, 
      isA: false, 
      isS: false, 
      isD: false,
      isSpace: false,
      isEnter: false
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
      isSpace: false,
      isEnter: false
    }
}

still :: Number
still = 0.0