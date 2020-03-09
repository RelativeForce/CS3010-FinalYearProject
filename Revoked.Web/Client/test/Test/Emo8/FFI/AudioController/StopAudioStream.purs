module Test.Emo8.FFI.AudioController.StopAudioStream ( 
    stopAudioStreamTests 
) where

import Prelude

import Data.Array(length, head)
import Data.Maybe (Maybe(..))
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)
import Effect.Class (liftEffect)
import Effect (Effect)

import Emo8.FFI.AudioController (_stopAudioStream, newAudioContext, AudioStream)

stopAudioStreamTests :: TestSuite
stopAudioStreamTests =
    suite "Emo8.FFI.AudioController - _stopAudioStream" do
        test "SHOULD stop AND remove audio stream WHEN the stream is active" do

            let 
                src = "testAudioFile"
                context = (newAudioContext "test") { audioStreams = [ { src: src } ] }
                stopperSucceeds = true
                    
            resultContext <- liftEffect $ _stopAudioStream (mockAudioStopper stopperSucceeds) context src

            equal 0 $ length resultContext.audioStreams

        test "SHOULD not remove audio stream WHEN stopper fails" do

            let 
                src = "testAudioFile"
                context = (newAudioContext "test") { audioStreams = [ { src: src } ] }
                stopperSucceeds = false
                
            resultContext <- liftEffect $ _stopAudioStream (mockAudioStopper stopperSucceeds) context src

            let 
                resultSrc = case head resultContext.audioStreams of 
                    Nothing -> "error"
                    Just as -> as.src 

            equal src resultSrc    

mockAudioStopper :: Boolean -> AudioStream -> Effect Boolean
mockAudioStopper expected audioStream = pure expected
