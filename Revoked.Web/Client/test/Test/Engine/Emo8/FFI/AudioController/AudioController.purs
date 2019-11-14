module Test.Engine.Emo8.FFI.AudioController( 
    audioControllerTests 
) where

import Prelude

import Effect (Effect)
import Test.Engine.Emo8.FFI.AudioController.AddAudioStream (addAudioStreamTests)
import Test.Unit.Main (runTest)

audioControllerTests :: Effect Unit
audioControllerTests = do
    -- Tests
    runTest do
        addAudioStreamTests
    -- Sub Modules