module Test.Engine.Emo8.Parse( 
    parseTests 
) where

import Test.Unit (TestSuite)

import Test.Engine.Emo8.Parse.MapSum (mapSumTests)

parseTests :: TestSuite
parseTests = do
    mapSumTests