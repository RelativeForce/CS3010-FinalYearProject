module Test.Revoked.Data.Gun ( 
    gunTests 
) where

import Prelude

import Test.Revoked.Data.Gun.Pistol (pistolTests)
import Test.Revoked.Data.Gun.Helper (helperTests)
import Test.Unit (TestSuite)

gunTests :: TestSuite
gunTests = do
    pistolTests
    helperTests