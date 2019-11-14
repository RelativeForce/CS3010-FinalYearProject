module Test.Engine.Emo8.FFI.AudioController.StopAudioStream ( 
    stopAudioStreamTests 
) where

import Prelude
import Emo8.FFI.AudioController (stopAudioStream, newAudioController, AudioStream)
import Data.Array(length, head)
import Data.Maybe (Maybe(..))
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)

stopAudioStreamTests :: TestSuite
stopAudioStreamTests =
    suite "Engine.Emo8.FFI.AudioController - stopAudioStream" do
        test "shouldStopAndRemoveAudioStreamWhenThatStreamIsActive" do

            let 
                src = "testAudioFile"
                controller = (newAudioController "test") { audioStreams = [ { src: src } ] }
                stopperSucceeds = true
                
                resultController = stopAudioStream (mockAudioStopper stopperSucceeds) controller src

            equal 0 $ length resultController.audioStreams

        test "shouldNotRemoveAudioStreamWhenStopperFails" do

            let 
                src = "testAudioFile"
                controller = (newAudioController "test") { audioStreams = [ { src: src } ] }
                stopperSucceeds = false
                
                resultController = stopAudioStream (mockAudioStopper stopperSucceeds) controller src
                resultControllerFirstAudioStream = head resultController.audioStreams

            equal src $ case resultControllerFirstAudioStream of 
                Nothing -> "error"
                Just as -> as.src


mockAudioStopper :: Boolean -> AudioStream -> Boolean
mockAudioStopper expected audioStream = expected
