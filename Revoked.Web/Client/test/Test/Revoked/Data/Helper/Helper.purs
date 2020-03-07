module Test.Revoked.Data.Helper ( 
    helperTests 
) where

import Test.Revoked.Data.Helper.IsDead (isDeadTests)
import Test.Unit (TestSuite)

helperTests :: TestSuite
helperTests = do
    isDeadTests