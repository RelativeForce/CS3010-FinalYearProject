module Test.Engine.Emo8.FFI.AudioController.StopAudioStream ( 
    stopAudioStreamTests 
) where

import Prelude
import Emo8.FFI.AudioController (_stopAudioStream, newAudioController, AudioStream, AudioController)
import Data.Array(length, head)
import Data.Maybe (Maybe(..))
import Test.Unit (suite, test)
import Test.Unit.Assert (equal)
import Test.Unit.Main (runTest)
import Effect (Effect)

stopAudioStreamTests :: Effect Unit
stopAudioStreamTests = do

    let testSrc = "testAudioFile"
    
    shouldStopAndRemoveAudioStreamWhenThatStreamIsActiveResult <- shouldStopAndRemoveAudioStreamWhenThatStreamIsActiveSetup testSrc  
    shouldNotRemoveAudioStreamWhenStopperFailsResult <- shouldNotRemoveAudioStreamWhenStopperFailsSetup testSrc

    runTest do
        suite "Engine.Emo8.FFI.AudioController - _stopAudioStream" do
            test "shouldStopAndRemoveAudioStreamWhenThatStreamIsActive" do

                equal 0 $ length shouldStopAndRemoveAudioStreamWhenThatStreamIsActiveResult.audioStreams

            test "shouldNotRemoveAudioStreamWhenStopperFails" do

                let resultControllerFirstAudioStream = head shouldNotRemoveAudioStreamWhenStopperFailsResult.audioStreams

                equal testSrc $ case resultControllerFirstAudioStream of 
                    Nothing -> "error"
                    Just as -> as.src

shouldNotRemoveAudioStreamWhenStopperFailsSetup :: String -> Effect AudioController
shouldNotRemoveAudioStreamWhenStopperFailsSetup src = do
    let 
        controller = (newAudioController "test") { audioStreams = [ { src: src } ] }
        stopperSucceeds = false
        
    _stopAudioStream (mockAudioStopper stopperSucceeds) controller src

shouldStopAndRemoveAudioStreamWhenThatStreamIsActiveSetup :: String -> Effect AudioController
shouldStopAndRemoveAudioStreamWhenThatStreamIsActiveSetup src = do
  
    let 
        controller = (newAudioController "test") { audioStreams = [ { src: src } ] }
        stopperSucceeds = true
        
    _stopAudioStream (mockAudioStopper stopperSucceeds) controller src

mockAudioStopper :: Boolean -> AudioStream -> Effect Boolean
mockAudioStopper expected audioStream = pure expected
