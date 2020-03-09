module Test.Revoked.Data.Player.UpdateAppear ( 
    updateAppearTests 
) where

import Prelude

import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)

import Emo8.Input (Input)

import Revoked.Data.Player (updateAppear, PlayerAppear(..))

updateAppearTests :: TestSuite
updateAppearTests =
    suite "Revoked.Data.Player - updateAppear" do
        test "SHOULD appear backward WHEN appearing backward AND input is both left and right" do
            let 
                appear = PlayerBackward
                isLeft = true
                isRight = true
                input = buildInput isLeft isRight
                expectedAppear = PlayerBackward

                result = updateAppear input appear
            equal true (expectedAppear == result)
        test "SHOULD appear backward WHEN appearing backward AND no input is pressed" do
            let 
                appear = PlayerBackward
                isLeft = false
                isRight = false
                input = buildInput isLeft isRight
                expectedAppear = PlayerBackward

                result = updateAppear input appear
            equal true (expectedAppear == result)
        test "SHOULD appear forward WHEN appearing backward AND input is right" do
            let 
                appear = PlayerBackward
                isLeft = false
                isRight = true
                input = buildInput isLeft isRight
                expectedAppear = PlayerForward

                result = updateAppear input appear
            equal true (expectedAppear == result)
        test "SHOULD appear forward WHEN appearing forward AND input is right" do
            let 
                appear = PlayerForward
                isLeft = false
                isRight = true
                input = buildInput isLeft isRight
                expectedAppear = PlayerForward

                result = updateAppear input appear
            equal true (expectedAppear == result)
        test "SHOULD appear backward WHEN appearing backward AND input is left" do
            let 
                appear = PlayerBackward
                isLeft = true
                isRight = false
                input = buildInput isLeft isRight
                expectedAppear = PlayerBackward

                result = updateAppear input appear
            equal true (expectedAppear == result)
        test "SHOULD appear backward WHEN appearing forward AND input is left" do
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
