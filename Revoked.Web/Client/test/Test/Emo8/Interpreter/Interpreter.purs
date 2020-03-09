module Test.Emo8.Interpreter ( 
    interpreterTests 
) where

import Test.Unit (TestSuite)

import Test.Emo8.Interpreter.Update (updateTests)

interpreterTests :: TestSuite
interpreterTests = do
    updateTests
