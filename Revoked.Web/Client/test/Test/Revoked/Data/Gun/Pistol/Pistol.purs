module Test.Revoked.Data.Gun.Pistol ( 
    pistolTests 
) where

import Test.Unit (TestSuite)

import Test.Revoked.Data.Gun.Pistol.CanFire (canFireTests)

pistolTests :: TestSuite
pistolTests = do
    canFireTests