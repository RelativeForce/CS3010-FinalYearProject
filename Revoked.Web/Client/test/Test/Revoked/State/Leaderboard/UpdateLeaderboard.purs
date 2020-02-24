module Test.Revoked.State.Leaderboard.UpdateLeaderboard (
    updateLeaderboardTests
) where

import Prelude

import Data.Either (Either(..))
import Effect.Class(liftEffect)
import Emo8.Types (PlayerScore)
import Emo8.Input (Input)
import States.Leaderboard (updateLeaderboard, initialLeaderboardState)
import States.StateIds as S
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)
import Emo8.Action.Update (UpdateF(..))
import Effect (Effect)
import Test.Revoked.State.Helper (runTestUpdateAllFail, runTestUpdate, interpretAllFail)

updateLeaderboardTests :: TestSuite
updateLeaderboardTests =
    suite "Revoked.State.Leaderboard - updateLeaderboard" do
        test "shouldReturnTitleScreenIdWithoutRetrievingTopScoresWhenBackSpaceIsPressedAndScoresAreAlreadyLoaded" do
            let 
                pressingBackspacePressed = true
                state = {
                    scores: [],
                    isWaiting: false,
                    isLoaded: true
                }
                input = buildInput pressingBackspacePressed

                expected = Right S.titleScreenId 
    
            result <- liftEffect $ runTestUpdateAllFail $ updateLeaderboard input state

            equal expected result
        test "shouldRetrieveTopScoresWhenInDefaultState" do
            let 
                pressingBackspacePressed = false
                state = initialLeaderboardState
                input = buildInput pressingBackspacePressed

                testScore = {
                    username: "TES",
                    score: 10,
                    time: "00:05:00",
                    position: 1
                }

                response = Right [ testScore ]

                expected = Left {
                    scores: [ testScore ],
                    isWaiting: false,
                    isLoaded: true
                }
    
            result <- liftEffect $ runTestUpdate (interpreterForLeaderboard response) $ updateLeaderboard input state

            equal expected result
        test "shouldWaitWhenScoresAreNotRetreivedWhenInDefaultState" do
            let 
                pressingBackspacePressed = false
                state = initialLeaderboardState
                input = buildInput pressingBackspacePressed

                response = Left "Waiting"

                expected = Left {
                    scores: [],
                    isWaiting: true,
                    isLoaded: false
                }
    
            result <- liftEffect $ runTestUpdate (interpreterForLeaderboard response) $ updateLeaderboard input state

            equal expected result

interpreterForLeaderboard :: Either String (Array PlayerScore) -> (UpdateF ~> Effect)
interpreterForLeaderboard response (ListTopScores f) = f <$> pure response
interpreterForLeaderboard _ a = interpretAllFail a

buildInput :: Boolean -> Input
buildInput pressingBackspaceButton = { 
    active: { 
        isSpace: false,
        isEnter: false,
        isBackspace: pressingBackspaceButton,
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