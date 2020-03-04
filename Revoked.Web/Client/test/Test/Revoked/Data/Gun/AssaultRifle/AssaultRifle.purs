module Test.Revoked.Data.Gun.AssaultRifle ( 
    assaultRifleTests 
) where

import Test.Revoked.Data.Gun.AssaultRifle.CanFire (canFireTests)
import Test.Unit (TestSuite)

assaultRifleTests :: TestSuite
assaultRifleTests = do
    canFireTests