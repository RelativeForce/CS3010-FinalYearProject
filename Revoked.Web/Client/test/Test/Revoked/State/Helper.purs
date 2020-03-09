module Test.Revoked.State.Helper where

import Prelude

import Control.Monad.Free (foldFree)
import Effect (Effect)
import Data.Either (Either(..))
import Effect.Exception (throw)
import Effect.Now (nowDateTime)
import Data.DateTime (DateTime)

import Emo8.Action.Update (Update, UpdateF(..))
import Emo8.FFI.AudioController (AudioContext, newAudioContext)

-- | Interprets a `Update` into an `Effect` where all of the `UpdateF` functors throw a `JavaScript` exception when 
-- | evaluated. The intended use for this is during tests where non of the `UpdateF` functors are expected to be used.
-- | A default value will be returned by each functor however this will never be used.
runTestUpdateAllFail :: forall a. Update a -> Effect a
runTestUpdateAllFail = runTestUpdate interpretAllFail

-- | Interprets a `Update` into an `Effect` with a given interpreter.
runTestUpdate :: forall a. (UpdateF ~> Effect) -> Update a -> Effect a
runTestUpdate interpreter = foldFree interpreter

-- | Interprets `UpdateF` functors into an `Effect` where a `JavaScript` exception is thrown when 
-- | evaluated. The intended use for this is during tests where non of the `UpdateF` functors are expected to be used.
-- | A default value will be returned by each functor however this will never be used.
interpretAllFail :: UpdateF ~> Effect
interpretAllFail (NowDateTime f) = f <$> errorOnCall (cannotCallMessage "NowDateTime") defaultDateTime
interpretAllFail (StorePlayerScore request f) = f <$> errorOnCall (cannotCallMessage "StorePlayerScore") defaultEither
interpretAllFail (ListTopScores f) = f <$> errorOnCall (cannotCallMessage "ListTopScores") defaultEither
interpretAllFail (AddAudioStream controller src f) = f <$> errorOnCall (cannotCallMessage "AddAudioStream") defaultAudioContext
interpretAllFail (IsAudioStreamPlaying controller src f) = f <$> errorOnCall (cannotCallMessage "IsAudioStreamPlaying") defaultBoolean
interpretAllFail (StopAudioStream controller src f) = f <$> errorOnCall (cannotCallMessage "StopAudioStream") defaultAudioContext
interpretAllFail (MuteAudio controller f) = f <$> errorOnCall (cannotCallMessage "MuteAudio") defaultAudioContext
interpretAllFail (UnmuteAudio controller f) = f <$> errorOnCall (cannotCallMessage "UnmuteAudio") defaultAudioContext

defaultAudioContext :: Effect AudioContext
defaultAudioContext = pure (newAudioContext "test")

defaultBoolean :: Effect Boolean
defaultBoolean = pure false

defaultDateTime :: Effect DateTime
defaultDateTime = nowDateTime

defaultEither :: forall a. Effect (Either String a)
defaultEither = pure (Left "Test")

cannotCallMessage :: String -> String
cannotCallMessage s = "Cannot call '" <> s <> "' during this test"

errorOnCall :: forall a. String -> (Effect a) -> Effect a
errorOnCall message defaultResult = do
    _ <- throw message
    defaultResult