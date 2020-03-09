module Test.Revoked.State.Victory.UpdateVictory (
    updateVictoryTests
) where

import Prelude

import Data.Either (Either(..))
import Effect.Class(liftEffect)
import Emo8.Input (Input)
import Revoked.States.Victory (updateVictory, inputInterval)
import Revoked.States.StateIds as S
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)
import Emo8.Action.Update (UpdateF(..))
import Effect (Effect)
import Test.Revoked.State.Helper (runTestUpdateAllFail, runTestUpdate, interpretAllFail)

updateVictoryTests :: TestSuite
updateVictoryTests =
    suite "Revoked.State.Victory - updateVictory" do
        test "SHOULD add username character WHEN character input is pressed AND username is empty" do
            let 
                pressingBackspacePressed = false
                pressingAButton = true
                pressingEnterButton = false
                initialInputInterval = 0 
                start = bottom
                end = top
                waiting = false
                state = {
                    username: [],
                    score: 10,
                    inputInterval: initialInputInterval,
                    start: start,
                    end: end,
                    isWaiting: waiting
                }
                input = buildInput pressingBackspacePressed pressingAButton pressingEnterButton

                expected = Left {
                    username: ["A"],
                    score: 10,
                    inputInterval: inputInterval,
                    start: start,
                    end: end,
                    isWaiting: waiting
                }
    
            result <- liftEffect $ runTestUpdateAllFail $ updateVictory input state

            equal expected result
        test "SHOULD not add username character WHEN character input is pressed AND input interval > 0" do
            let 
                pressingBackspacePressed = false
                pressingAButton = true
                pressingEnterButton = false
                initialInputInterval = 0 
                start = bottom
                end = top
                waiting = false
                state = {
                    username: ["A"],
                    score: 10,
                    inputInterval: inputInterval,
                    start: start,
                    end: end,
                    isWaiting: waiting
                }
                input = buildInput pressingBackspacePressed pressingAButton pressingEnterButton

                expected = Left {
                    username: ["A"],
                    score: 10,
                    inputInterval: inputInterval - 1,
                    start: start,
                    end: end,
                    isWaiting: waiting
                }
    
            result <- liftEffect $ runTestUpdateAllFail $ updateVictory input state

            equal expected result
        test "SHOULD not submit score WHEN enter is pressed AND username is not 3 characters long" do
            let 
                pressingBackspacePressed = false
                pressingAButton = false
                pressingEnterButton = true
                initialInputInterval = 0 
                start = bottom
                end = top
                waiting = false
                state = {
                    username: ["A"],
                    score: 10,
                    inputInterval: initialInputInterval,
                    start: start,
                    end: end,
                    isWaiting: waiting
                }
                input = buildInput pressingBackspacePressed pressingAButton pressingEnterButton

                expected = Left {
                    username: ["A"],
                    score: 10,
                    inputInterval: initialInputInterval,
                    start: start,
                    end: end,
                    isWaiting: waiting
                }
    
            result <- liftEffect $ runTestUpdateAllFail $ updateVictory input state

            equal expected result
        test "SHOULD not add username character WHEN character input is pressed AND username is 3 characters long" do
            let 
                pressingBackspacePressed = false
                pressingAButton = true
                pressingEnterButton = false
                initialInputInterval = 0 
                start = bottom
                end = top
                waiting = false
                state = {
                    username: ["A", "B", "C"],
                    score: 10,
                    inputInterval: initialInputInterval,
                    start: start,
                    end: end,
                    isWaiting: waiting
                }
                input = buildInput pressingBackspacePressed pressingAButton pressingEnterButton

                expected = Left {
                    username: ["A", "B", "C"],
                    score: 10,
                    inputInterval: initialInputInterval,
                    start: start,
                    end: end,
                    isWaiting: waiting
                }
    
            result <- liftEffect $ runTestUpdateAllFail $ updateVictory input state

            equal expected result
        test "SHOULD submit score AND wait WHEN enter is pressed AND username is 3 characters long" do
            let 
                pressingBackspacePressed = false
                pressingAButton = false
                pressingEnterButton = true
                initialInputInterval = 0 
                start = bottom
                end = top
                waiting = false
                state = {
                    username: ["A", "B", "C"],
                    score: 10,
                    inputInterval: initialInputInterval,
                    start: start,
                    end: end,
                    isWaiting: waiting
                }
                input = buildInput pressingBackspacePressed pressingAButton pressingEnterButton
                response = Left "Waiting"

                expected = Left {
                    username: ["A", "B", "C"],
                    score: 10,
                    inputInterval: initialInputInterval,
                    start: start,
                    end: end,
                    isWaiting: true
                }
    
            result <- liftEffect $ runTestUpdate (interpreterForVictory response) $ updateVictory input state

            equal expected result
        test "SHOULD go to title screen WHEN waiting AND recieves sumbit success" do
            let 
                pressingBackspacePressed = false
                pressingAButton = false
                pressingEnterButton = false
                initialInputInterval = 0 
                start = bottom
                end = top
                waiting = true
                state = {
                    username: ["A", "B", "C"],
                    score: 10,
                    inputInterval: initialInputInterval,
                    start: start,
                    end: end,
                    isWaiting: waiting
                }
                input = buildInput pressingBackspacePressed pressingAButton pressingEnterButton
                response = Right true

                expected = Right S.titleScreenId 

            result <- liftEffect $ runTestUpdate (interpreterForVictory response) $ updateVictory input state

            equal expected result

interpreterForVictory :: Either String Boolean -> (UpdateF ~> Effect)
interpreterForVictory response (StorePlayerScore request f) = f <$> pure response
interpreterForVictory _ a = interpretAllFail a

buildInput :: Boolean -> Boolean -> Boolean -> Input
buildInput pressingBackspaceButton pressingAButton pressingEnterButton = { 
    active: { 
        isSpace: false,
        isEnter: pressingEnterButton,
        isBackspace: pressingBackspaceButton,
        isA: pressingAButton,
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