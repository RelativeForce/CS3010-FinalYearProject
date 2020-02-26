module Test.Engine.Emo8.FFI.AudioController.IsAudioStreamPlaying ( 
    isAudioStreamPlayingTests 
) where

import Prelude
import Emo8.FFI.AudioController (_isAudioStreamPlaying, newAudioContext, AudioStream)
import Test.Unit (suite, test)
import Test.Unit.Assert (equal)
import Test.Unit.Main (runTest)
import Effect (Effect)

isAudioStreamPlayingTests :: Effect Unit
isAudioStreamPlayingTests = do

    shouldReturnPlayingAudioStreamWhenCheckerReturnsTrueResult <- shouldReturnPlayingAudioStreamWhenCheckerReturnsTrueSetup
    shouldReturnNotPlayingAudioStreamWhenCheckerReturnsFalseResult <- shouldReturnNotPlayingAudioStreamWhenCheckerReturnsFalseSetup
    
    runTest do
        suite "Engine.Emo8.FFI.AudioController - _isAudioStreamPlaying" do
            test "shouldReturnPlayingAudioStreamWhenCheckerReturnsTrue" do

                let expectedResult = true

                equal expectedResult $ shouldReturnPlayingAudioStreamWhenCheckerReturnsTrueResult

            test "shouldReturnNotPlayingAudioStreamWhenCheckerReturnsFalse" do

                let expectedResult = false

                equal expectedResult $ shouldReturnNotPlayingAudioStreamWhenCheckerReturnsFalseResult

shouldReturnNotPlayingAudioStreamWhenCheckerReturnsFalseSetup :: Effect Boolean
shouldReturnNotPlayingAudioStreamWhenCheckerReturnsFalseSetup = do
    let 
        src = "testAudioFile"
        controller = (newAudioContext "test") { audioStreams = [ { src: src } ] }
        checkerSucceeds = false
        
    _isAudioStreamPlaying (mockAudioChecker checkerSucceeds) controller src

shouldReturnPlayingAudioStreamWhenCheckerReturnsTrueSetup :: Effect Boolean
shouldReturnPlayingAudioStreamWhenCheckerReturnsTrueSetup = do
    let 
        src = "testAudioFile"
        controller = (newAudioContext "test") { audioStreams = [ { src: src } ] }
        checkerSucceeds = true
        
    _isAudioStreamPlaying (mockAudioChecker checkerSucceeds) controller src

mockAudioChecker :: Boolean -> AudioStream -> Effect Boolean
mockAudioChecker expected audioStream = pure expected
