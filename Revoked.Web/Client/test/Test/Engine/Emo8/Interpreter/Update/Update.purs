module Test.Emo8.Interpreter.Update ( 
    updateTests 
) where

import Test.Emo8.Interpreter.Update.EncodePlayerScore (encodePlayerScoreTests)
import Test.Unit (TestSuite)

updateTests :: TestSuite
updateTests = do
    encodePlayerScoreTests
