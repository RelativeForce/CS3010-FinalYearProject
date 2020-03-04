module Test.Revoked.Data.Gun.Blaster ( 
    blasterTests 
) where

import Test.Revoked.Data.Gun.Blaster.CanFire (canFireTests)
import Test.Unit (TestSuite)

blasterTests :: TestSuite
blasterTests = do
    canFireTests