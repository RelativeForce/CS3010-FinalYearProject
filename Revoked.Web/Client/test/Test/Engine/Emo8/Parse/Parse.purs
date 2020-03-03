module Test.Engine.Emo8.Parse( 
    parseTests 
) where

import Test.Engine.Emo8.Parse.MapSum (mapSumTests)
import Test.Unit (TestSuite)

parseTests :: TestSuite
parseTests = do
    mapSumTests