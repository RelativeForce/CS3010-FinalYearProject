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

-- | Represents the context of the Audio playing at a moment in time. The state 
-- | of the `AudioStream`s in the given `AudioContext` can change but the functions 
-- | used to evaluate that change are all non-pure.
type AudioContext = {
    id :: String,
    muted :: Boolean,
    audioStreams :: Array AudioStream
}

-- | A wrapper for a audio stream that has a given source.
type AudioStream = {
    src :: String
}

-- | See partner PureScript function for documentation
foreign import play :: (AudioStream -> Maybe AudioStream) -> (Maybe AudioStream) -> Boolean -> String -> Effect (Maybe AudioStream)
foreign import isPlaying :: AudioStream -> Effect Boolean
foreign import stop :: AudioStream -> Effect Boolean
foreign import mute :: AudioContext -> Effect AudioContext
foreign import unmute :: AudioContext -> Effect AudioContext

-- | Creates a new `AudioContext` with a given Id `String`.
-- | Arguments
-- | - `String`: the id of the new `AudioContext`
-- | Returns
-- | - `Effect AudioContext`: once evaluated, the new audio context 
newAudioContext :: String -> AudioContext
newAudioContext controllerId = {
    id: controllerId,
    muted: false,
    audioStreams: []
}

-- | Mutes all the `AudioStream`s in the given `AudioContext`. If all `AudioStream`s are muted 
-- | then this function does nothing.
-- | Arguments
-- | - `AudioContext`: the audio context
-- | Returns
-- | - `Effect AudioContext`: once evaluated, the muted audio context
muteAudio :: AudioContext -> Effect AudioContext
muteAudio context = do
    mutedController <- mute context
    pure $ mutedController { muted = true }

-- | Unmutes all the `AudioStream`s in the given `AudioContext`. If no `AudioStream`s are muted 
-- | then this function does nothing.
-- | Arguments
-- | - `AudioContext`: the audio context
-- | Returns
-- | - `Effect AudioContext`: once evaluated, the unmuted audio context
unmuteAudio :: AudioContext -> Effect AudioContext
unmuteAudio context = do
    unmutedController <- unmute context
    pure $ unmutedController { muted = false }

-- | Finds a `AudioStream` in a given `AudioContext` by its source if such an `AudioStream` exists.
findStreamBySource :: AudioContext -> String -> Maybe AudioStream
findStreamBySource context src = find (\a -> a.src == src) context.audioStreams

-- | Removes a `AudioStream` from a given `AudioContext` by its source if such an `AudioStream` exists.
filterOutStreamsBySource :: AudioContext -> String -> Array AudioStream
filterOutStreamsBySource context src = filter (\a -> a.src /= src) context.audioStreams

-- | Adds an `AudioStream` to the given `AudioContext` and start it. The `AudioStream` will be muted initially if the 
-- | `AudioContext.muted` is true. Only one `AudioStream` of each audio source should be playing at once. Uses a 
-- | given `AudioStream` player function.
_addAudioStream :: (Boolean -> String -> Effect (Maybe AudioStream)) -> AudioContext -> String -> Effect AudioContext
_addAudioStream player context src = do
    
    -- Start the audio stream playing
    maybeAudioStream <- player context.muted src

    -- If the stream is successfully playing add it to the context (replacing any existing instances)
    let newAudioStreams = case maybeAudioStream of 
            Just newAudio -> [ newAudio ] <> filterOutStreamsBySource context src
            Nothing -> context.audioStreams

    -- Return the new audio context
    pure $ context { audioStreams = newAudioStreams }        

-- | Adds an `AudioStream` to the given `AudioContext` and start it. The `AudioStream` will be muted initially if the 
-- | `AudioContext.muted` is true. Only one `AudioStream` of each audio source should be playing at once.
-- | Arguments
-- | - `AudioContext`: the audio context
-- | - `String`: the source of the audio (network path to audio file)
-- | Returns
-- | - `Effect AudioContext`: once evaluated, the audio context containing the new `AudioStream`
addAudioStream :: AudioContext -> String -> Effect AudioContext
addAudioStream = _addAudioStream $ play (Just) (Nothing)

-- | Checks if a `AudioStream` is currently playing in the `AudioContext`. If the audio stream has finished 
-- | or has been stopped then this will be false. Uses a given `AudioContext` checking function.
_isAudioStreamPlaying :: (AudioStream -> Effect Boolean) -> AudioContext -> String -> Effect Boolean
_isAudioStreamPlaying checker context src = do

    -- Retrieve the audio stream from the context
    let maybeAudioStream = findStreamBySource context src

    -- If the audio stream exists check if its playing and return the result.
    case maybeAudioStream of
        Nothing -> pure false
        Just audioStream -> checker audioStream

-- | Checks if a `AudioStream` is currently playing in the `AudioContext`. If the audio stream has finished 
-- | or has been stopped then this will be false.
-- | Arguments
-- | - `AudioContext`: the audio context
-- | - `String`: the source of the audio (network path to audio file)
-- | Returns
-- | - `Effect Boolean`: once evaluated, whether or not the specified `AudioStream` is currently playing. 
isAudioStreamPlaying :: AudioContext -> String -> Effect Boolean
isAudioStreamPlaying = _isAudioStreamPlaying isPlaying

-- | Ends a specified `AudioStream` in the given `AudioContext` and `AudioStream` ending function.
_stopAudioStream :: (AudioStream -> Effect Boolean) -> AudioContext -> String -> Effect AudioContext
_stopAudioStream stopper context src = do
    
    -- Retrieve the audio stream from the context
    let maybeAudioStream = findStreamBySource context src
    
    newAudioStreams <- case maybeAudioStream of
        Nothing -> pure context.audioStreams
        Just audioStream -> do 

            -- Attempt to stop the audio
            stopped <- stopper audioStream

            -- If the track was stopped then remove it from the context, otherwise dont.
            if stopped 
                then pure $ filterOutStreamsBySource context src 
                else pure $ context.audioStreams
    
    -- Return the new context
    pure $ context { audioStreams = newAudioStreams }        

-- | Ends a specified `AudioStream` in the given `AudioContext`.
-- | Arguments
-- | - `AudioContext`: the audio context
-- | - `String`: the source of the audio (network path to audio file)
-- | Returns
-- | - `Effect AudioContext`: once evaluated, the audio context without the specified `AudioStream`
stopAudioStream :: AudioContext -> String -> Effect AudioContext
stopAudioStream = _stopAudioStream stop