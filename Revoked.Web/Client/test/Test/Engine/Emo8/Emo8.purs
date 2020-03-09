module Test.Engine.Emo8 ( 
    emo8Tests 
) where

import Prelude

import Test.Unit (TestSuite)

import Test.Engine.Emo8.Utils (utilsTests)
import Test.Engine.Emo8.Data (dataTests)
import Test.Engine.Emo8.Parse (parseTests)
import Test.Engine.Emo8.FFI (ffiTests)
import Test.Engine.Emo8.Interpreter (interpreterTests)

emo8Tests :: TestSuite
emo8Tests = do
    ffiTests
    dataTests
    parseTests
    interpreterTests
    utilsTests
