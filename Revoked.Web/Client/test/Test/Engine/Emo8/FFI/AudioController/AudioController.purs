module Test.Engine.Emo8.FFI.AudioController( 
    audioControllerTests 
) where

import Prelude

import Test.Engine.Emo8.FFI.AudioController.AddAudioStream (addAudioStreamTests)
import Test.Engine.Emo8.FFI.AudioController.StopAudioStream (stopAudioStreamTests)
import Test.Engine.Emo8.FFI.AudioController.IsAudioStreamPlaying (isAudioStreamPlayingTests)
import Test.Unit (TestSuite)

audioControllerTests :: TestSuite
audioControllerTests = do
    addAudioStreamTests
    stopAudioStreamTests
    isAudioStreamPlayingTests
    
    