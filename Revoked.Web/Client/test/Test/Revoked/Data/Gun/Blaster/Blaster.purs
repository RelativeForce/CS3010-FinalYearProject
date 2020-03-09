module Test.Revoked.Data.Gun.Blaster ( 
    blasterTests 
) where

import Test.Unit (TestSuite)

import Test.Revoked.Data.Gun.Blaster.CanFire (canFireTests)

blasterTests :: TestSuite
blasterTests = do
    canFireTests