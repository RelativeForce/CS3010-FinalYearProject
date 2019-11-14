module Test.Engine.Emo8.FFI.AudioController( 
    audioControllerTests 
) where

import Prelude

import Effect (Effect)
import Test.Engine.Emo8.FFI.AudioController.AddAudioStream (addAudioStreamTests)
import Test.Engine.Emo8.FFI.AudioController.StopAudioStream (stopAudioStreamTests)
import Test.Unit.Main (runTest)

audioControllerTests :: Effect Unit
audioControllerTests = do
    -- Tests
    runTest do
        addAudioStreamTests
        stopAudioStreamTests
    -- Sub Modules