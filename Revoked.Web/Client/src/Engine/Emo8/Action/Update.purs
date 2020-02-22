module Emo8.Action.Update where

import Prelude

import Control.Monad.Free (Free, liftF)
import Data.DateTime (DateTime)
import Data.Either (Either)
import Emo8.FFI.AudioController (AudioController)
import Emo8.Types (PlayerScore, PlayerScoreCreateRequestData)

type Update = Free UpdateF

data UpdateF n
    = NowDateTime (DateTime -> n)
    | StorePlayerScore PlayerScoreCreateRequestData (Either String Boolean -> n)
    | ListTopScores (Either String (Array PlayerScore) -> n) 
    | AddAudioStream AudioController String (AudioController -> n)
    | IsAudioStreamPlaying AudioController String (Boolean -> n)
    | StopAudioStream AudioController String (AudioController -> n)
    | MuteAudio AudioController (AudioController -> n)
    | UnmuteAudio AudioController (AudioController -> n)

nowDateTime :: Update DateTime
nowDateTime = liftF $ NowDateTime identity

storePlayerScore :: PlayerScoreCreateRequestData -> Update (Either String Boolean)
storePlayerScore request = liftF $ StorePlayerScore request identity

listTopScores :: Update (Either String (Array PlayerScore))
listTopScores = liftF $ ListTopScores identity

addAudioStream :: AudioController -> String -> Update AudioController
addAudioStream controller src = liftF $ AddAudioStream controller src identity

isAudioStreamPlaying :: AudioController -> String -> Update Boolean
isAudioStreamPlaying controller src = liftF $ IsAudioStreamPlaying controller src identity

stopAudioStream :: AudioController -> String -> Update AudioController
stopAudioStream controller src = liftF $ StopAudioStream controller src identity

muteAudio :: AudioController -> Update AudioController
muteAudio controller = liftF $ MuteAudio controller identity

unmuteAudio :: AudioController -> Update AudioController
unmuteAudio controller = liftF $ UnmuteAudio controller identity