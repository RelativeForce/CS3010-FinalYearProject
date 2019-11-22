module Test.Engine.Emo8.FFI.AudioController( 
    audioControllerTests 
) where

import Prelude

import Effect (Effect)
import Test.Engine.Emo8.FFI.AudioController.AddAudioStream (addAudioStreamTests)
import Test.Engine.Emo8.FFI.AudioController.StopAudioStream (stopAudioStreamTests)
import Test.Engine.Emo8.FFI.AudioController.IsAudioStreamPlaying (isAudioStreamPlayingTests)

audioControllerTests :: Effect Unit
audioControllerTests = do
    -- Tests
        
    -- Sub Modules
    addAudioStreamTests
    stopAudioStreamTests
    isAudioStreamPlayingTests