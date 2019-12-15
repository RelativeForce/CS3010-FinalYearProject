module Test.Revoked.Data.Player.UpdateEnergy ( 
    updateEnergyTests 
) where

import Prelude
import Emo8.Input (Input)
import Data.Player (updateEnergy)
import Test.Unit (TestSuite, suite, test)
import Constants (playerShotCooldown)
import Test.Unit.Assert (equal)

updateEnergyTests :: TestSuite
updateEnergyTests =
    suite "Revoked.Data.Player - updateEnergy" do
        test "energyShouldIncrementByOneWhenNoInputIsPressed" do
            let 
                pressingEnterButton = false
                currentEnergy = 0
                expectedEnergy = 1
                input = buildInput pressingEnterButton

                result = updateEnergy currentEnergy input
            equal expectedEnergy result
        test "energyShouldIncrementByOneWhenEnterIsPressed" do
            let 
                pressingEnterButton = true
                currentEnergy = 0
                expectedEnergy = 1
                input = buildInput pressingEnterButton

                result = updateEnergy currentEnergy input
            equal expectedEnergy result
        test "energyShouldRemainTheSameWhenNoInputIsPressedAndEnergyIsAtMax" do
            let 
                pressingEnterButton = false
                currentEnergy = playerShotCooldown
                expectedEnergy = playerShotCooldown
                input = buildInput pressingEnterButton

                result = updateEnergy currentEnergy input
            equal expectedEnergy result
        test "energyShouldResetToZeroWhenEnterIsPressedAndEnergyIsAtMax" do
            let 
                pressingEnterButton = true
                currentEnergy = playerShotCooldown
                expectedEnergy = 0
                input = buildInput pressingEnterButton

                result = updateEnergy currentEnergy input
            equal expectedEnergy result

buildInput :: Boolean -> Input
buildInput pressingEnterButton  = { 
    active: {
        isLeft: false, 
        isRight: false, 
        isUp: false, 
        isDown: false,  
        isSpace: false,
        isEnter: pressingEnterButton,
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
    catched: {
        isLeft: false, 
        isRight: false, 
        isUp: false, 
        isDown: false,  
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
        isLeft: false, 
        isRight: false, 
        isUp: false, 
        isDown: false,  
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
