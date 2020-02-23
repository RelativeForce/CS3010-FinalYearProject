module Emo8.Action.Update where

import Prelude

import Control.Monad.Free (Free, liftF)
import Data.DateTime (DateTime)
import Data.Either (Either)
import Emo8.FFI.AudioController (AudioContext)
import Emo8.Types (PlayerScore, PlayerScoreCreateRequestData)

type Update = Free UpdateF

data UpdateF n
    = NowDateTime (DateTime -> n)
    | StorePlayerScore PlayerScoreCreateRequestData (Either String Boolean -> n)
    | ListTopScores (Either String (Array PlayerScore) -> n) 
    | AddAudioStream AudioContext String (AudioContext -> n)
    | IsAudioStreamPlaying AudioContext String (Boolean -> n)
    | StopAudioStream AudioContext String (AudioContext -> n)
    | MuteAudio AudioContext (AudioContext -> n)
    | UnmuteAudio AudioContext (AudioContext -> n)

nowDateTime :: Update DateTime
nowDateTime = liftF $ NowDateTime identity

storePlayerScore :: PlayerScoreCreateRequestData -> Update (Either String Boolean)
storePlayerScore request = liftF $ StorePlayerScore request identity

listTopScores :: Update (Either String (Array PlayerScore))
listTopScores = liftF $ ListTopScores identity

addAudioStream :: AudioContext -> String -> Update AudioContext
addAudioStream controller src = liftF $ AddAudioStream controller src identity

isAudioStreamPlaying :: AudioContext -> String -> Update Boolean
isAudioStreamPlaying controller src = liftF $ IsAudioStreamPlaying controller src identity

stopAudioStream :: AudioContext -> String -> Update AudioContext
stopAudioStream controller src = liftF $ StopAudioStream controller src identity

muteAudio :: AudioContext -> Update AudioContext
muteAudio controller = liftF $ MuteAudio controller identity

unmuteAudio :: AudioContext -> Update AudioContext
unmuteAudio controller = liftF $ UnmuteAudio controller identity