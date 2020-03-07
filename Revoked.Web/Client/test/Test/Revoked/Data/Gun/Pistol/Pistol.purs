module Test.Revoked.Data.Gun.Pistol ( 
    pistolTests 
) where

import Test.Revoked.Data.Gun.Pistol.CanFire (canFireTests)
import Test.Unit (TestSuite)

pistolTests :: TestSuite
pistolTests = do
    canFireTests