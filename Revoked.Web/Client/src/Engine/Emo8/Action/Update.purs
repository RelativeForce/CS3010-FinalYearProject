module Emo8.Action.Update where

import Prelude

import Control.Monad.Free (Free, liftF)
import Data.DateTime (DateTime)
import Data.Either (Either)

import Emo8.FFI.AudioController (AudioContext)
import Emo8.Types (PlayerScore, PlayerScoreCreateRequestData)

type Update = Free UpdateF

-- | The data type that defines the ajoint functors that represent the non-pure operations 
-- | required to update the games state. A function is required to 
-- | interpret these operations into update operations which can be defined on a per 
-- | output basis.
data UpdateF n
    = NowDateTime (DateTime -> n)
    | StorePlayerScore PlayerScoreCreateRequestData (Either String Boolean -> n)
    | ListTopScores (Either String (Array PlayerScore) -> n) 
    | AddAudioStream AudioContext String (AudioContext -> n)
    | IsAudioStreamPlaying AudioContext String (Boolean -> n)
    | StopAudioStream AudioContext String (AudioContext -> n)
    | MuteAudio AudioContext (AudioContext -> n)
    | UnmuteAudio AudioContext (AudioContext -> n)

-- | The current date time at the point this is interpreted
nowDateTime :: Update DateTime
nowDateTime = liftF $ NowDateTime identity

-- | Stores a player score in persistent storage.
-- | Arguments
-- | - `PlayerScoreCreateRequestData`: the player score data to be stored
-- | Returns
-- | - `Update (Either String Boolean)`: once interpreted, either a message (`String`) regarding the current in progress status of the request or the success status (`Boolean`) of the request.
storePlayerScore :: PlayerScoreCreateRequestData -> Update (Either String Boolean)
storePlayerScore request = liftF $ StorePlayerScore request identity

-- | Retrieve the top X scores from persistent storage.
-- | Returns
-- | - `Update (Either String (Array PlayerScore))`: once interpreted, either a message (`String`) regarding the current in progress status of retriveing the top scores or an list (`Array`) of the top `PlayerScore`s in decending order.
listTopScores :: Update (Either String (Array PlayerScore))
listTopScores = liftF $ ListTopScores identity

-- | Adds an `AudioStream` to the given `AudioContext` and start it. The `AudioStream` will be muted initially if the `AudioContext.muted` is true. Only one `AudioStream` of each audio source should be playing at once.
-- | Arguments
-- | - `AudioContext`: the audio context
-- | - `String`: the source of the audio (network path to audio file)
-- | Returns
-- | - `Update AudioContext`: once interpreted, the audio context containing the new `AudioStream`
addAudioStream :: AudioContext -> String -> Update AudioContext
addAudioStream controller src = liftF $ AddAudioStream controller src identity

-- | Checks if a `AudioStream` is currently playing in the `AudioContext`. If the audio stream has finished or has been stopped then this will be false.
-- | Arguments
-- | - `AudioContext`: the audio context
-- |- `String`: the source of the audio (network path to audio file)
-- | Returns
-- | - `Update Boolean`: once interpreted, whether or not the specified `AudioStream` is currently playing. 
isAudioStreamPlaying :: AudioContext -> String -> Update Boolean
isAudioStreamPlaying controller src = liftF $ IsAudioStreamPlaying controller src identity

-- | Ends a specified `AudioStream` in the given `AudioContext`.
-- | Arguments
-- | - `AudioContext`: the audio context
-- | - `String`: the source of the audio (network path to audio file)
-- | Returns
-- | - `Update AudioContext`: once interpreted, the audio context without the specified `AudioStream`
stopAudioStream :: AudioContext -> String -> Update AudioContext
stopAudioStream controller src = liftF $ StopAudioStream controller src identity

-- | Mutes all the `AudioStream`s in the given `AudioContext`. If all `AudioStream`s are muted then this function does nothing.
-- | Arguments
-- | - `AudioContext`: the audio context 
-- |Returns
-- | - `Update AudioContext`: once interpreted, the muted audio context
muteAudio :: AudioContext -> Update AudioContext
muteAudio controller = liftF $ MuteAudio controller identity

-- | Unmutes all the `AudioStream`s in the given `AudioContext`. If no `AudioStream`s are muted then this function does nothing.
-- | Arguments
-- | - `AudioContext`: the audio context
-- | Returns
-- | - `Update AudioContext`: once interpreted, the unmuted audio context
unmuteAudio :: AudioContext -> Update AudioContext
unmuteAudio controller = liftF $ UnmuteAudio controller identity