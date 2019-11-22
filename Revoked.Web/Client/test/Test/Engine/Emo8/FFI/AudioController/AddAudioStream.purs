module Test.Engine.Emo8.FFI.AudioController.AddAudioStream ( 
    addAudioStreamTests 
) where

import Prelude
import Emo8.FFI.AudioController (_addAudioStream, newAudioController, AudioStream, AudioController)
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

shouldNotAddAudioStreamWhenPlayerFailsSetup :: String -> Effect AudioController
shouldNotAddAudioStreamWhenPlayerFailsSetup src = do
    let controller = newAudioController "test"
        
    _addAudioStream mockAudioPlayerThatFails controller src

shouldAddAudioStreamWhenThereIsNoAudioStreamsActiveSetup :: String -> Effect AudioController
shouldAddAudioStreamWhenThereIsNoAudioStreamsActiveSetup src = do
    let 
        controller = newAudioController "test"

    _addAudioStream mockAudioPlayer controller src

mockAudioPlayer :: String -> Effect (Maybe AudioStream)
mockAudioPlayer src = pure $ Just { src: src }

mockAudioPlayerThatFails :: String -> Effect (Maybe AudioStream)
mockAudioPlayerThatFails src = pure Nothing
