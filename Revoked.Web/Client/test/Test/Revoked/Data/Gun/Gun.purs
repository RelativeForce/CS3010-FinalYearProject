module Test.Revoked.Data.Gun ( 
    gunTests 
) where

import Prelude

import Test.Unit (TestSuite)

-- Sub Modules
import Test.Revoked.Data.Gun.Pistol (pistolTests)
import Test.Revoked.Data.Gun.Shotgun (shotgunTests)
import Test.Revoked.Data.Gun.AssaultRifle (assaultRifleTests)
import Test.Revoked.Data.Gun.Blaster (blasterTests)

-- Tests
import Test.Revoked.Data.Gun.IsInfinite (isInfiniteTests)
import Test.Revoked.Data.Gun.ShotCount (shotCountTests)

gunTests :: TestSuite
gunTests = do
    pistolTests
    shotgunTests
    assaultRifleTests
    blasterTests
    isInfiniteTests
    shotCountTests