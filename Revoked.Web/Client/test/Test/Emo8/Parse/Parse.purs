module Test.Emo8.Parse( 
    parseTests 
) where

import Test.Unit (TestSuite)

import Test.Emo8.Parse.MapSum (mapSumTests)

parseTests :: TestSuite
parseTests = do
    mapSumTests