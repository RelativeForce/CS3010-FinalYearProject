module Test.Revoked.Data.Helper ( 
    helperTests 
) where

import Test.Unit (TestSuite)

import Test.Revoked.Data.Helper.IsDead (isDeadTests)

helperTests :: TestSuite
helperTests = do
    isDeadTests