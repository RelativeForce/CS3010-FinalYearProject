module Test.Revoked.Data.Gun.AssaultRifle.CanFire ( 
    canFireTests 
) where

import Prelude

import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)

import Revoked.Data.Gun.AssaultRifle (AssaultRifle, canFire, defaultAssaultRifle)

canFireTests :: TestSuite
canFireTests =
    suite "Revoked.Data.Gun.AssaultRifle - canFire" do
        test "SHOULD be false WHEN out of ammo" do
            let 
                shotCount = 0
                shotCoolDown = 0

                expected = false 

                result = canFire $ buildAssaultRifle shotCount shotCoolDown
            equal expected result
        test "SHOULD be false WHEN cooling down" do
            let 
                shotCount = 1
                shotCoolDown = 1

                expected = false 

                result = canFire $ buildAssaultRifle shotCount shotCoolDown
            equal expected result
        test "SHOULD be true WHEN has ammo AND not cooling down" do
            let 
                shotCount = 1
                shotCoolDown = 0

                expected = true 

                result = canFire $ buildAssaultRifle shotCount shotCoolDown
            equal expected result

buildAssaultRifle :: Int -> Int -> AssaultRifle
buildAssaultRifle shotCount shotCoolDown = p
    where 
        basic = defaultAssaultRifle { x: 0, y: 0 } 0
        p = basic { 
            shotCount = shotCount,
            shotCoolDown = shotCoolDown 
        }