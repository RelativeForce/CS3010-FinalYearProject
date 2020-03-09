module Test.Emo8.FFI.AudioController.IsAudioStreamPlaying ( 
    isAudioStreamPlayingTests 
) where

import Prelude

import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)
import Effect.Class (liftEffect)
import Effect (Effect)

import Emo8.FFI.AudioController (_isAudioStreamPlaying, newAudioContext, AudioStream)

isAudioStreamPlayingTests :: TestSuite
isAudioStreamPlayingTests = 
    suite "Emo8.FFI.AudioController - _isAudioStreamPlaying" do
        test "SHOULD return playing WHEN checker determines audio stream is playing" do

            let 
                src = "testAudioFile"
                controller = (newAudioContext "test") { audioStreams = [ { src: src } ] }
                checkerSucceeds = true
                
                expectedResult = true

            result <- liftEffect $ _isAudioStreamPlaying (mockAudioChecker checkerSucceeds) controller src

            equal expectedResult result

        test "SHOULD return not playing WHEN checker determines audio stream is not playing" do

            let 
                src = "testAudioFile"
                controller = (newAudioContext "test") { audioStreams = [ { src: src } ] }
                checkerSucceeds = false
                        
                expectedResult = false

            result <- liftEffect $ _isAudioStreamPlaying (mockAudioChecker checkerSucceeds) controller src

            equal expectedResult $ result

mockAudioChecker :: Boolean -> AudioStream -> Effect Boolean
mockAudioChecker expected audioStream = pure expected
