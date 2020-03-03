module Test.Engine ( 
    engineTests 
) where

import Test.Engine.Emo8 (emo8Tests)
import Test.Unit (TestSuite)

engineTests :: TestSuite
engineTests = do
    emo8Tests
