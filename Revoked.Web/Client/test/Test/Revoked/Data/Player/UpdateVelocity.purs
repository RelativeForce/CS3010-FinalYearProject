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
        test "SHOULD apply gravity" do
            let 
                velocity = { xSpeed: still, ySpeed: still }
                onFloor = false
                pressingJumpButton = false
                input = buildInput pressingJumpButton false false

                result = updateVelocity input velocity onFloor
            equal still result.xSpeed
            equal (still + gravity) result.ySpeed
        test "SHOULD jump WHEN on floor AND pressing jump button" do
            let 
                velocity = { xSpeed: still, ySpeed: still }
                onFloor = true
                pressingJumpButton = true
                input = buildInput pressingJumpButton false false

                result = updateVelocity input velocity onFloor
            equal still result.xSpeed
            equal maxPlayerSpeedY result.ySpeed
        test "SHOULD not exceed max player speed WHEN falling" do
            let 
                velocity = { xSpeed: still, ySpeed: -maxPlayerSpeedY }
                onFloor = false
                pressingJumpButton = false
                input = buildInput pressingJumpButton false false

                result = updateVelocity input velocity onFloor
            equal still result.xSpeed
            equal (-maxPlayerSpeedY) result.ySpeed
        test "SHOULD apply friction WHEN moving horizontally" do
            let 
                velocity = { xSpeed: 1.0, ySpeed: still }
                onFloor = true
                input = buildInput false false false

                result = updateVelocity input velocity onFloor
            equal frictionFactor result.xSpeed
            equal gravity result.ySpeed
        test "SHOULD set max speed WHEN pressing left button" do
            let 
                velocity = { xSpeed: still, ySpeed: still }
                onFloor = true
                pressingLeftButton = true
                input = buildInput false pressingLeftButton false

                result = updateVelocity input velocity onFloor
            equal (-maxPlayerSpeedX) result.xSpeed
            equal gravity result.ySpeed
        test "SHOULD set max speed WHEN pressing right button" do
            let 
                velocity = { xSpeed: still, ySpeed: still }
                onFloor = true
                pressingRightButton = true
                input = buildInput false false pressingRightButton

                result = updateVelocity input velocity onFloor
            equal maxPlayerSpeedX result.xSpeed
            equal gravity result.ySpeed
            
still :: Number
still = 0.0

buildInput :: Boolean -> Boolean -> Boolean -> Input
buildInput pressingJumpButton pressingLeftButton pressingRightButton = { 
    active: { 
        isSpace: pressingJumpButton,
        isEnter: false,
        isBackspace: false,
        isA: pressingLeftButton,
        isB: false,  
        isC: false, 
        isD: pressingRightButton,
        isE: false, 
        isF: false, 
        isG: false, 
        isH: false, 
        isI: false, 
        isJ: false, 
        isK: false, 
        isL: false, 
        isM: false, 
        isN: false, 
        isO: false, 
        isP: false, 
        isQ: false, 
        isR: false, 
        isS: false,
        isT: false, 
        isU: false,  
        isV: false, 
        isW: false,
        isX: false, 
        isY: false, 
        isZ: false
    },
    catched: {
        isSpace: false,
        isEnter: false,
        isBackspace: false,
        isA: false,
        isB: false,  
        isC: false, 
        isD: false,
        isE: false, 
        isF: false, 
        isG: false, 
        isH: false, 
        isI: false, 
        isJ: false, 
        isK: false, 
        isL: false, 
        isM: false, 
        isN: false, 
        isO: false, 
        isP: false, 
        isQ: false, 
        isR: false, 
        isS: false,
        isT: false, 
        isU: false,  
        isV: false, 
        isW: false,
        isX: false, 
        isY: false, 
        isZ: false
    }, 
    released: {
        isSpace: false,
        isEnter: false,
        isBackspace: false,
        isA: false,
        isB: false,  
        isC: false, 
        isD: false,
        isE: false, 
        isF: false, 
        isG: false, 
        isH: false, 
        isI: false, 
        isJ: false, 
        isK: false, 
        isL: false, 
        isM: false, 
        isN: false, 
        isO: false, 
        isP: false, 
        isQ: false, 
        isR: false, 
        isS: false,
        isT: false, 
        isU: false,  
        isV: false, 
        isW: false,
        isX: false, 
        isY: false, 
        isZ: false
      }
}
