module Test.Emo8.Interpreter.Update ( 
    updateTests 
) where

import Prelude

import Effect (Effect)
import Test.Emo8.Interpreter.Update.EncodePlayerScore (encodePlayerScoreTests)
import Test.Unit.Main (runTest)

updateTests :: Effect Unit
updateTests = do
    -- Tests
    runTest do
        encodePlayerScoreTests
    -- Sub Modules