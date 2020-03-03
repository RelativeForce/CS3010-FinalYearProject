module Test.Engine.Emo8.Interpreter ( 
    interpreterTests 
) where

import Test.Emo8.Interpreter.Update (updateTests)
import Test.Unit (TestSuite)

interpreterTests :: TestSuite
interpreterTests = do
    updateTests
