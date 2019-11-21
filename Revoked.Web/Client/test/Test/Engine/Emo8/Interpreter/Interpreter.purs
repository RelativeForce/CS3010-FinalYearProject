module Test.Engine.Emo8.Interpreter ( 
    interpreterTests 
) where

import Prelude

import Effect (Effect)
import Test.Emo8.Interpreter.Update (updateTests)

interpreterTests :: Effect Unit
interpreterTests = do
    -- Tests

    -- Sub Modules
    updateTests
