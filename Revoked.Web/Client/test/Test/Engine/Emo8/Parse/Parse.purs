module Test.Engine.Emo8.Parse( 
    parseTests 
) where

import Prelude

import Effect (Effect)
import Test.Unit.Main (runTest)
import Test.Engine.Emo8.Parse.ParseSound (parseSoundTests)
import Test.Engine.Emo8.Parse.MapSum (mapSumTests)
import Test.Engine.Emo8.Parse.SoundSum (soundSumTests)

parseTests :: Effect Unit
parseTests = do
    -- Tests
    runTest do
        parseSoundTests
        mapSumTests
        soundSumTests
    -- Sub Modules

    