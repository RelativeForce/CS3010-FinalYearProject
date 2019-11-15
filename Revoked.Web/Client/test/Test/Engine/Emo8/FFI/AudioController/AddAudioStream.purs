module Test.Engine.Emo8.FFI.AudioController.AddAudioStream ( 
    addAudioStreamTests 
) where

import Prelude
import Emo8.FFI.AudioController (addAudioStream, newAudioController, AudioStream)
import Data.Array(head)
import Data.Maybe (Maybe(..))
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)

addAudioStreamTests :: TestSuite
addAudioStreamTests =
    suite "Engine.Emo8.FFI.AudioController - addAudioStream" do
        test "shouldAddAudioStreamWhenThereIsNoAudioStreamsActive" do

            let 
                controller = newAudioController "test"
                src = "testAudioFile"

                resultController = addAudioStream mockAudioPlayer controller src
                resultControllerFirstAudioStream = head resultController.audioStreams

            equal src $ case resultControllerFirstAudioStream of 
                Nothing -> "error"
                Just as -> as.src
        test "shouldNotAddAudioStreamWhenPlayerFails" do

            let 
                src = "testAudioFile"
                controller = newAudioController "test"
                
                resultController = addAudioStream mockAudioPlayerThatFails controller src
                resultControllerFirstAudioStream = head resultController.audioStreams

            equal Nothing resultControllerFirstAudioStream 


mockAudioPlayer :: String -> Maybe AudioStream
mockAudioPlayer src = Just { src: src }

mockAudioPlayerThatFails :: String -> Maybe AudioStream
mockAudioPlayerThatFails src = Nothing
