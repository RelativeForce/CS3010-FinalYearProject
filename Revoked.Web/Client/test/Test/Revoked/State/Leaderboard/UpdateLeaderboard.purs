module Test.Revoked.State.Leaderboard.UpdateLeaderboard (
    updateLeaderboardTests
) where

import Prelude

import Control.Monad.Free (foldFree)
import Data.Either (Either(..))
import Effect (Effect)
import Effect.Class(liftEffect)
import Effect.Exception (throw)
import Effect.Now (nowDateTime)
import Emo8.Action.Update (Update, UpdateF(..))
import Emo8.FFI.AudioController (newAudioContext)
import Emo8.Input (Input)
import Emo8.Types (StateId)
import States.Leaderboard (LeaderboardState, updateLeaderboard)
import States.StateIds as S
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)

updateLeaderboardTests :: TestSuite
updateLeaderboardTests =
    suite "Test.Revoked.State.Leaderboard - updateLeaderboard" do
        test "shouldReturnTitleScreenIdWithoutRetrievingTopScoresWhenBackSpaceIsPressedAndScoresAreLoaded" do
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

runTestUpdateAllFail :: Update (Either LeaderboardState StateId) -> Effect (Either LeaderboardState StateId)
runTestUpdateAllFail = foldFree interpret
  where
    interpret :: UpdateF ~> Effect
    interpret (NowDateTime f) = f <$> errorOnCall "Cannot call 'NowDateTime' during test" nowDateTime
    interpret (StorePlayerScore request f) = f <$> errorOnCall "Cannot call 'StorePlayerScore' during test" (pure (Left "Test"))
    interpret (ListTopScores f) = f <$> errorOnCall "Cannot call 'ListTopScores' during test" (pure (Left "Test"))
    interpret (AddAudioStream controller src f) = f <$> errorOnCall "Cannot call 'AddAudioStream' during test" (pure (newAudioContext "test"))
    interpret (IsAudioStreamPlaying controller src f) = f <$> errorOnCall "Cannot call 'IsAudioStreamPlaying' during test" (pure false)
    interpret (StopAudioStream controller src f) = f <$> errorOnCall "Cannot call 'StopAudioStream' during test" (pure (newAudioContext "test"))
    interpret (MuteAudio controller f) = f <$> errorOnCall "Cannot call 'MuteAudio' during test" (pure (newAudioContext "test"))
    interpret (UnmuteAudio controller f) = f <$> errorOnCall "Cannot call 'UnmuteAudio' during test" (pure (newAudioContext "test"))

errorOnCall :: forall a. String -> (Effect a) -> Effect a
errorOnCall message f = do
    _ <- throw message
    f

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