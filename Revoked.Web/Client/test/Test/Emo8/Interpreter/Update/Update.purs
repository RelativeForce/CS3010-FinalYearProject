module Test.Engine.Emo8.Interpreter.Update ( 
    updateTests 
) where

import Test.Unit (TestSuite)

import Test.Engine.Emo8.Interpreter.Update.EncodePlayerScore (encodePlayerScoreTests)

updateTests :: TestSuite
updateTests = do
    encodePlayerScoreTests
