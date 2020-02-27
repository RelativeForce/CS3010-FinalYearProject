module Test.Engine.Emo8.FFI.AudioController( 
    audioControllerTests 
) where

import Prelude

import Effect (Effect)
import Test.Engine.Emo8.FFI.AudioController.AddAudioStream (addAudioStreamTests)
import Test.Engine.Emo8.FFI.AudioController.StopAudioStream (stopAudioStreamTests)
import Test.Engine.Emo8.FFI.AudioController.IsAudioStreamPlaying (isAudioStreamPlayingTests)
import Test.Unit.Main (runTest)

audioControllerTests :: Effect Unit
audioControllerTests = do
    -- Sub Modules

    -- Tests
    runTest do
        addAudioStreamTests
        stopAudioStreamTests
        isAudioStreamPlayingTests
    
    