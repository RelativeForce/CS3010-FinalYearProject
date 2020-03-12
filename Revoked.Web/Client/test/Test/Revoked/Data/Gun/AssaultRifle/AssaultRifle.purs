module Test.Revoked.Data.Gun.AssaultRifle ( 
    assaultRifleTests 
) where

import Test.Unit (TestSuite)

import Test.Revoked.Data.Gun.AssaultRifle.CanFire (canFireTests)

assaultRifleTests :: TestSuite
assaultRifleTests = do
    canFireTests