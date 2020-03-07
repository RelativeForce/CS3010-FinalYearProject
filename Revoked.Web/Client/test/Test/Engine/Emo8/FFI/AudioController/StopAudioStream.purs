module Test.Engine.Emo8.FFI.AudioController.StopAudioStream ( 
    stopAudioStreamTests 
) where

import Prelude
import Emo8.FFI.AudioController (_stopAudioStream, newAudioContext, AudioStream)
import Data.Array(length, head)
import Data.Maybe (Maybe(..))
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)
import Effect.Class (liftEffect)
import Effect (Effect)

stopAudioStreamTests :: TestSuite
stopAudioStreamTests =
    suite "Engine.Emo8.FFI.AudioController - _stopAudioStream" do
        test "SHOULD stop AND remove audio stream WHEN the stream is active" do

            let 
                src = "testAudioFile"
                controller = (newAudioContext "test") { audioStreams = [ { src: src } ] }
                stopperSucceeds = true
                    
            result <- liftEffect $ _stopAudioStream (mockAudioStopper stopperSucceeds) controller src

            equal 0 $ length result.audioStreams

        test "SHOULD not remove audio stream WHEN stopper fails" do

            let 
                src = "testAudioFile"
                controller = (newAudioContext "test") { audioStreams = [ { src: src } ] }
                stopperSucceeds = false
                
            result <- liftEffect $ _stopAudioStream (mockAudioStopper stopperSucceeds) controller src

            let 
                resultSrc = case head result.audioStreams of 
                    Nothing -> "error"
                    Just as -> as.src 

            equal src resultSrc    

mockAudioStopper :: Boolean -> AudioStream -> Effect Boolean
mockAudioStopper expected audioStream = pure expected
