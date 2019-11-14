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
import Data.Maybe (Maybe(..))
import Data.Array (filter, find)

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

filterOutStreamsBySource :: AudioController -> String -> Array AudioStream
filterOutStreamsBySource controller src = filter (\a -> a.src /= src) controller.audioStreams

addAudioStream :: (String -> Maybe AudioStream) -> AudioController -> String -> AudioController
addAudioStream player controller src = controller { audioStreams = newAudioStreams }
    where 
        maybeAudioStream = player src
        newAudioStreams = case maybeAudioStream of 
            Just newAudio -> [ newAudio ] <> filterOutStreamsBySource controller src
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

stopAudioStream :: (AudioStream -> Boolean) -> AudioController -> String -> AudioController
stopAudioStream stopper controller src = controller { audioStreams = newAudioStreams }
    where
        maybeAudioStream = findStreamBySource controller src
        newAudioStreams = case maybeAudioStream of
            Nothing -> controller.audioStreams
            Just audioStream -> if stopper audioStream then filterOutStreamsBySource controller src else controller.audioStreams

_stopAudioStream :: AudioController -> String -> AudioController
_stopAudioStream = stopAudioStream stop