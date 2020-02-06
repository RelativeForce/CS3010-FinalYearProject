module Test.Revoked.Data.Player.UpdateAppear ( 
    updateAppearTests 
) where

import Prelude
import Emo8.Input (Input)
import Data.Player (updateAppear, PlayerAppear(..))
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)

updateAppearTests :: TestSuite
updateAppearTests =
    suite "Revoked.Data.Player - updateAppear" do
        test "shouldUpdateAppearToCurrentAppear [ appear = PlayerBackward, isLeft = true, isRight = true ]" do
            let 
                appear = PlayerBackward
                isLeft = true
                isRight = true
                input = buildInput isLeft isRight
                expectedAppear = PlayerBackward

                result = updateAppear input appear
            equal true (expectedAppear == result)
        test "shouldUpdateAppearToCurrentAppear [ appear = PlayerBackward, isLeft = false, isRight = false ]" do
            let 
                appear = PlayerBackward
                isLeft = false
                isRight = false
                input = buildInput isLeft isRight
                expectedAppear = PlayerBackward

                result = updateAppear input appear
            equal true (expectedAppear == result)
        test "shouldUpdateAppearToForwardWhenInputIsRight [ appear = PlayerBackward, isLeft = false ]" do
            let 
                appear = PlayerBackward
                isLeft = false
                isRight = true
                input = buildInput isLeft isRight
                expectedAppear = PlayerForward

                result = updateAppear input appear
            equal true (expectedAppear == result)
        test "shouldUpdateAppearToForwardWhenInputIsRight [ appear = PlayerForward, isLeft = false ]" do
            let 
                appear = PlayerForward
                isLeft = false
                isRight = true
                input = buildInput isLeft isRight
                expectedAppear = PlayerForward

                result = updateAppear input appear
            equal true (expectedAppear == result)
        test "shouldUpdateAppearToBackwardWhenInputIsLeft [ appear = PlayerBackward, isRight = false ]" do
            let 
                appear = PlayerBackward
                isLeft = true
                isRight = false
                input = buildInput isLeft isRight
                expectedAppear = PlayerBackward

                result = updateAppear input appear
            equal true (expectedAppear == result)
        test "shouldUpdateAppearToBackwardWhenInputIsLeft [ appear = PlayerForward, isRight = false ]" do
            let 
                appear = PlayerForward
                isLeft = true
                isRight = false
                input = buildInput isLeft isRight
                expectedAppear = PlayerBackward

                result = updateAppear input appear
            equal true (expectedAppear == result)

buildInput :: Boolean -> Boolean -> Input
buildInput  pressingLeftButton pressingRightButton = { 
    active: {
        isSpace: false,
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
