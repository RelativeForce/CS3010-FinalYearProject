module Emo8.FFI.AudioController (
    AudioController,
    AudioStream,
    newAudioController,
    addAudioStream,
    _addAudioStream,
    isAudioStreamPlaying,
    _isAudioStreamPlaying,
    stopAudioStream,
    _stopAudioStream
) where

import Prelude
import Data.Foldable (find)
import Data.Maybe (Maybe(..))

type AudioController = {
    id :: String,
    audioStreams :: Array AudioStream
}

type AudioStream = {
    src :: String
}

foreign import play :: (AudioStream -> Maybe AudioStream) -> (Maybe AudioStream) -> String -> Maybe AudioStream

foreign import isPlaying :: AudioStream -> Boolean

foreign import stop :: AudioStream -> Boolean

newAudioController :: String -> AudioController
newAudioController controllerId = {
    id: controllerId,
    audioStreams: []
}

findStreamBySource :: AudioController -> String -> Maybe AudioStream
findStreamBySource controller src = find (\a -> a.src == src) controller.audioStreams

addAudioStream :: (String -> Maybe AudioStream) -> AudioController -> String -> AudioController
addAudioStream player controller src = controller { audioStreams = newAudioStreams }
    where 
        maybeAudioStream = player src
        newAudioStreams = case maybeAudioStream of 
            Just newAudio -> controller.audioStreams <> [ newAudio ]
            Nothing -> controller.audioStreams

_addAudioStream :: AudioController -> String -> AudioController
_addAudioStream = addAudioStream $ play (Just) (Nothing)

isAudioStreamPlaying :: (AudioStream -> Boolean) -> AudioController -> String -> Boolean
isAudioStreamPlaying checker controller src = result
    where
        maybeAudioStream = findStreamBySource controller src
        result = case maybeAudioStream of
            Nothing -> false
            Just audioStream -> checker audioStream

_isAudioStreamPlaying :: AudioController -> String -> Boolean
_isAudioStreamPlaying = isAudioStreamPlaying isPlaying

stopAudioStream :: (AudioStream -> Boolean) -> AudioController -> String -> Boolean
stopAudioStream stopper controller src = result
    where
        maybeAudioStream = findStreamBySource controller src
        result = case maybeAudioStream of
            Nothing -> false
            Just audioStream -> stopper audioStream

_stopAudioStream :: AudioController -> String -> Boolean
_stopAudioStream = stopAudioStream stop