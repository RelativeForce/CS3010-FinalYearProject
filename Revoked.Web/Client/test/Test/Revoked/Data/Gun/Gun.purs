module Test.Revoked.Data.Gun ( 
    gunTests 
) where

import Prelude

import Test.Unit (TestSuite)

-- Sub Modules
import Test.Revoked.Data.Gun.Pistol (pistolTests)

-- Tests
import Test.Revoked.Data.Gun.IsInfinite (isInfiniteTests)

gunTests :: TestSuite
gunTests = do
    pistolTests
    isInfiniteTests