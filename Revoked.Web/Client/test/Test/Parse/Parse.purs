module Test.Parse( 
    parseTests 
) where

import Prelude

import Effect (Effect)
import Test.Unit.Main (runTest)
import Test.ParseSound (parseSoundTests)
import Test.Parse.MapSum (mapSumTests)
import Test.Parse.SoundSum (soundSumTests)

parseTests :: Effect Unit
parseTests = do
    -- Tests
    runTest do
        parseSoundTests
        mapSumTests
        soundSumTests
    -- Sub Modules

    