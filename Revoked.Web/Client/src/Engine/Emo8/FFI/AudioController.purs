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
import Effect (Effect)

type AudioController = {
    id :: String,
    audioStreams :: Array AudioStream
}

type AudioStream = {
    src :: String
}

foreign import play :: (AudioStream -> Maybe AudioStream) -> (Maybe AudioStream) -> String -> Effect (Maybe AudioStream)

foreign import isPlaying :: AudioStream -> Effect Boolean

foreign import stop :: AudioStream -> Effect Boolean

newAudioController :: String -> AudioController
newAudioController controllerId = {
    id: controllerId,
    audioStreams: []
}

findStreamBySource :: AudioController -> String -> Maybe AudioStream
findStreamBySource controller src = find (\a -> a.src == src) controller.audioStreams

filterOutStreamsBySource :: AudioController -> String -> Array AudioStream
filterOutStreamsBySource controller src = filter (\a -> a.src /= src) controller.audioStreams

_addAudioStream :: (String -> Effect (Maybe AudioStream)) -> AudioController -> String -> Effect AudioController
_addAudioStream player controller src = do
    
    maybeAudioStream <- player src

    let newAudioStreams = case maybeAudioStream of 
            Just newAudio -> [ newAudio ] <> filterOutStreamsBySource controller src
            Nothing -> controller.audioStreams

    pure $ controller { audioStreams = newAudioStreams }        

addAudioStream :: AudioController -> String -> Effect AudioController
addAudioStream = _addAudioStream $ play (Just) (Nothing)

_isAudioStreamPlaying :: (AudioStream -> Effect Boolean) -> AudioController -> String -> Effect Boolean
_isAudioStreamPlaying checker controller src = do
    let maybeAudioStream = findStreamBySource controller src
    case maybeAudioStream of
        Nothing -> pure false
        Just audioStream -> checker audioStream

isAudioStreamPlaying :: AudioController -> String -> Effect Boolean
isAudioStreamPlaying = _isAudioStreamPlaying isPlaying

_stopAudioStream :: (AudioStream -> Effect Boolean) -> AudioController -> String -> Effect AudioController
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

stopAudioStream :: AudioController -> String -> Effect AudioController
stopAudioStream = _stopAudioStream stop