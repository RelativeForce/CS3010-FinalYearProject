module Test.Emo8.FFI.AudioController.AddAudioStream ( 
    addAudioStreamTests 
) where

import Prelude

import Data.Array (head)
import Data.Maybe (Maybe(..))
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)
import Effect.Class (liftEffect)
import Effect (Effect)

import Emo8.FFI.AudioController (_addAudioStream, newAudioContext, AudioStream)

addAudioStreamTests :: TestSuite
addAudioStreamTests =
    suite "Emo8.FFI.AudioController - _addAudioStream" do
        test "SHOULD add audio stream WHEN no audio streams are active" do

            let
                testSrc = "testAudioFile"
                context = newAudioContext "test" 
            
            resultContext <- liftEffect $ _addAudioStream mockAudioPlayer context testSrc

            let 
                resultSrc = case head resultContext.audioStreams of 
                    Nothing -> "error"
                    Just as -> as.src

            equal testSrc resultSrc
        test "SHOULD not add audio stream WHEN player fails" do

            let 
                testSrc = "testAudioFile"
                context = newAudioContext "test"

            resultContext <- liftEffect $ _addAudioStream mockAudioPlayerThatFails context testSrc

            equal Nothing $ head resultContext.audioStreams     

mockAudioPlayer :: Boolean -> String -> Effect (Maybe AudioStream)
mockAudioPlayer _ src = pure $ Just { src: src }

mockAudioPlayerThatFails :: Boolean -> String -> Effect (Maybe AudioStream)
mockAudioPlayerThatFails _ _ = pure Nothing
