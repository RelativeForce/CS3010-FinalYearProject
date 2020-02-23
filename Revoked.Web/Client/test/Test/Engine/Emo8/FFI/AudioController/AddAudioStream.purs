module Test.Engine.Emo8.FFI.AudioController.AddAudioStream ( 
    addAudioStreamTests 
) where

import Prelude
import Emo8.FFI.AudioController (_addAudioStream, newAudioContext, AudioStream, AudioContext)
import Data.Array(head)
import Data.Maybe (Maybe(..))
import Test.Unit (suite, test)
import Test.Unit.Assert (equal)
import Test.Unit.Main (runTest)
import Effect (Effect)

addAudioStreamTests :: Effect Unit
addAudioStreamTests = do

    let testSrc = "testAudioFile"
    shouldAddAudioStreamWhenThereIsNoAudioStreamsActiveResult <- shouldAddAudioStreamWhenThereIsNoAudioStreamsActiveSetup testSrc
    shouldNotAddAudioStreamWhenPlayerFailsResult <- shouldNotAddAudioStreamWhenPlayerFailsSetup testSrc

    runTest do
        suite "Engine.Emo8.FFI.AudioController - _addAudioStream" do
            test "shouldAddAudioStreamWhenThereIsNoAudioStreamsActive" do

                let resultControllerFirstAudioStream = head shouldAddAudioStreamWhenThereIsNoAudioStreamsActiveResult.audioStreams

                equal testSrc $ case resultControllerFirstAudioStream of 
                    Nothing -> "error"
                    Just as -> as.src
            test "shouldNotAddAudioStreamWhenPlayerFails" do

                let resultControllerFirstAudioStream = head shouldNotAddAudioStreamWhenPlayerFailsResult.audioStreams

                equal Nothing resultControllerFirstAudioStream 

shouldNotAddAudioStreamWhenPlayerFailsSetup :: String -> Effect AudioContext
shouldNotAddAudioStreamWhenPlayerFailsSetup src = do
    let controller = newAudioContext "test"
        
    _addAudioStream mockAudioPlayerThatFails controller src

shouldAddAudioStreamWhenThereIsNoAudioStreamsActiveSetup :: String -> Effect AudioContext
shouldAddAudioStreamWhenThereIsNoAudioStreamsActiveSetup src = do
    let 
        controller = newAudioContext "test"

    _addAudioStream mockAudioPlayer controller src

mockAudioPlayer :: Boolean -> String -> Effect (Maybe AudioStream)
mockAudioPlayer _ src = pure $ Just { src: src }

mockAudioPlayerThatFails :: Boolean -> String -> Effect (Maybe AudioStream)
mockAudioPlayerThatFails _ _ = pure Nothing
