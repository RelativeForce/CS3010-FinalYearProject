module Test.Revoked.Data.Gun ( 
    gunTests 
) where

import Prelude

import Test.Unit (TestSuite)

-- Sub Modules
import Test.Revoked.Data.Gun.Pistol (pistolTests)

-- Tests
import Test.Revoked.Data.Gun.IsInfinite (isInfiniteTests)
import Test.Revoked.Data.Gun.ShotCount (shotCountTests)

gunTests :: TestSuite
gunTests = do
    pistolTests
    isInfiniteTests
    shotCountTests