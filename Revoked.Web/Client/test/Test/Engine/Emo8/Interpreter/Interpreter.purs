module Test.Engine.Emo8.Interpreter ( 
    interpreterTests 
) where

import Test.Unit (TestSuite)

import Test.Engine.Emo8.Interpreter.Update (updateTests)

interpreterTests :: TestSuite
interpreterTests = do
    updateTests
