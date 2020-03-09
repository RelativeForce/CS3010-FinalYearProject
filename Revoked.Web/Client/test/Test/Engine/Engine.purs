module Test.Engine ( 
    engineTests 
) where

import Test.Unit (TestSuite)

import Test.Engine.Emo8 (emo8Tests)

engineTests :: TestSuite
engineTests = do
    emo8Tests
