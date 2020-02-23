module Emo8.FFI.AudioController (
    AudioContext,
    AudioStream,
    newAudioContext,
    addAudioStream,
    _addAudioStream,
    isAudioStreamPlaying,
    _isAudioStreamPlaying,
    stopAudioStream,
    _stopAudioStream,
    muteAudio,
    unmuteAudio
) where

import Prelude
import Data.Maybe (Maybe(..))
import Data.Array (filter, find)
import Effect (Effect)

type AudioContext = {
    id :: String,
    muted :: Boolean,
    audioStreams :: Array AudioStream
}

type AudioStream = {
    src :: String
}

foreign import play :: (AudioStream -> Maybe AudioStream) -> (Maybe AudioStream) -> Boolean -> String -> Effect (Maybe AudioStream)

foreign import isPlaying :: AudioStream -> Effect Boolean

foreign import stop :: AudioStream -> Effect Boolean

foreign import mute :: AudioContext -> Effect AudioContext

foreign import unmute :: AudioContext -> Effect AudioContext

newAudioContext :: String -> AudioContext
newAudioContext controllerId = {
    id: controllerId,
    muted: false,
    audioStreams: []
}

muteAudio :: AudioContext -> Effect AudioContext
muteAudio controller = do
    mutedController <- mute controller
    pure $ mutedController { muted = true }

unmuteAudio :: AudioContext -> Effect AudioContext
unmuteAudio controller = do
    unmutedController <- unmute controller
    pure $ unmutedController { muted = false }

findStreamBySource :: AudioContext -> String -> Maybe AudioStream
findStreamBySource controller src = find (\a -> a.src == src) controller.audioStreams

filterOutStreamsBySource :: AudioContext -> String -> Array AudioStream
filterOutStreamsBySource controller src = filter (\a -> a.src /= src) controller.audioStreams

_addAudioStream :: (Boolean -> String -> Effect (Maybe AudioStream)) -> AudioContext -> String -> Effect AudioContext
_addAudioStream player controller src = do
    
    maybeAudioStream <- player controller.muted src

    let newAudioStreams = case maybeAudioStream of 
            Just newAudio -> [ newAudio ] <> filterOutStreamsBySource controller src
            Nothing -> controller.audioStreams

    pure $ controller { audioStreams = newAudioStreams }        

addAudioStream :: AudioContext -> String -> Effect AudioContext
addAudioStream = _addAudioStream $ play (Just) (Nothing)

_isAudioStreamPlaying :: (AudioStream -> Effect Boolean) -> AudioContext -> String -> Effect Boolean
_isAudioStreamPlaying checker controller src = do
    let maybeAudioStream = findStreamBySource controller src
    case maybeAudioStream of
        Nothing -> pure false
        Just audioStream -> checker audioStream

isAudioStreamPlaying :: AudioContext -> String -> Effect Boolean
isAudioStreamPlaying = _isAudioStreamPlaying isPlaying

_stopAudioStream :: (AudioStream -> Effect Boolean) -> AudioContext -> String -> Effect AudioContext
_stopAudioStream stopper controller src = do
    
    let maybeAudioStream = findStreamBySource controller src
    
    newAudioStreams <- case maybeAudioStream of
        Nothing -> pure controller.audioStreams
        Just audioStream -> do 
            stopped <- stopper audioStream
            if stopped 
                then pure $ filterOutStreamsBySource controller src 
                else pure $ controller.audioStreams
    
    pure $ controller { audioStreams = newAudioStreams }        

stopAudioStream :: AudioContext -> String -> Effect AudioContext
stopAudioStream = _stopAudioStream stop