module Test.Emo8 ( 
    emo8Tests 
) where

import Prelude

import Test.Unit (TestSuite)

import Test.Emo8.Utils (utilsTests)
import Test.Emo8.Data (dataTests)
import Test.Emo8.Parse (parseTests)
import Test.Emo8.FFI (ffiTests)
import Test.Emo8.Interpreter (interpreterTests)

emo8Tests :: TestSuite
emo8Tests = do
    ffiTests
    dataTests
    parseTests
    interpreterTests
    utilsTests
