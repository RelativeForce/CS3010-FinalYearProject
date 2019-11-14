module Test.Engine.Emo8.Parse( 
    parseTests 
) where

import Prelude

import Effect (Effect)
import Test.Unit.Main (runTest)
import Test.Engine.Emo8.Parse.MapSum (mapSumTests)

parseTests :: Effect Unit
parseTests = do
    -- Tests
    runTest do
        mapSumTests
    -- Sub Modules

    