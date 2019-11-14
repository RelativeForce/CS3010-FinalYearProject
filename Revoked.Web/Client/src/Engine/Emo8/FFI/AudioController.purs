module Emo8.FFI.AudioController where

import Prelude

type AudioController = {
    id :: String,
    stop :: String -> Boolean,
    isPlaying :: String -> Boolean,
    play :: String -> Boolean
}

foreign import newAudioController :: String -> AudioController