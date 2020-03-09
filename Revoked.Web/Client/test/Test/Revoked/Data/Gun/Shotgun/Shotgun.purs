module Test.Revoked.Data.Gun.Shotgun ( 
    shotgunTests 
) where

import Test.Unit (TestSuite)

import Test.Revoked.Data.Gun.Shotgun.CanFire (canFireTests)

shotgunTests :: TestSuite
shotgunTests = do
    canFireTests