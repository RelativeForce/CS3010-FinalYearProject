module Test.Engine.Emo8 ( 
    emo8Tests 
) where

import Prelude

import Effect (Effect)
import Test.Engine.Emo8.Data (dataTests)
import Test.Engine.Emo8.Parse (parseTests)
import Test.Engine.Emo8.FFI (ffiTests)

emo8Tests :: Effect Unit
emo8Tests = do
    -- Tests

    -- Sub Modules
    ffiTests
    dataTests
    parseTests
