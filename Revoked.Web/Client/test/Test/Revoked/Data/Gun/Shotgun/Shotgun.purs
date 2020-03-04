module Test.Revoked.Data.Gun.Shotgun ( 
    shotgunTests 
) where

import Test.Revoked.Data.Gun.Shotgun.CanFire (canFireTests)
import Test.Unit (TestSuite)

shotgunTests :: TestSuite
shotgunTests = do
    canFireTests