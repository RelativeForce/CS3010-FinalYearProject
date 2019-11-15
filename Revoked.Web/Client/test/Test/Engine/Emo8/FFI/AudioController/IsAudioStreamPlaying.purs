module Test.Engine.Emo8.FFI.AudioController.IsAudioStreamPlaying ( 
    isAudioStreamPlayingTests 
) where

import Prelude
import Emo8.FFI.AudioController (isAudioStreamPlaying, newAudioController, AudioStream)
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)

isAudioStreamPlayingTests :: TestSuite
isAudioStreamPlayingTests =
    suite "Engine.Emo8.FFI.AudioController - isAudioStreamPlaying" do
        test "shouldReturnPlayingAudioStreamWhenCheckerReturnsTrue" do

            let 
                src = "testAudioFile"
                controller = (newAudioController "test") { audioStreams = [ { src: src } ] }
                checkerSucceeds = true
                expectedResult = true
                
                result = isAudioStreamPlaying (mockAudioChecker checkerSucceeds) controller src

            equal expectedResult $ result

        test "shouldReturnNotPlayingAudioStreamWhenCheckerReturnsFalse" do

            let 
                src = "testAudioFile"
                controller = (newAudioController "test") { audioStreams = [ { src: src } ] }
                checkerSucceeds = false
                expectedResult = false
                
                result = isAudioStreamPlaying (mockAudioChecker checkerSucceeds) controller src

            equal expectedResult $ result


mockAudioChecker :: Boolean -> AudioStream -> Boolean
mockAudioChecker expected audioStream = expected
