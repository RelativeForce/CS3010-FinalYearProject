module Test.Revoked.Data.Gun.Shotgun.CanFire ( 
    canFireTests 
) where

import Prelude

import Revoked.Data.Gun.Shotgun (Shotgun, canFire, defaultShotgun)
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)

canFireTests :: TestSuite
canFireTests =
    suite "Revoked.Data.Gun.Shotgun - canFire" do
        test "SHOULD be false WHEN out of ammo" do
            let 
                shotCount = 0
                shotCoolDown = 0

                expected = false 

                result = canFire $ buildShotgun shotCount shotCoolDown
            equal expected result
        test "SHOULD be false WHEN cooling down" do
            let 
                shotCount = 1
                shotCoolDown = 1

                expected = false 

                result = canFire $ buildShotgun shotCount shotCoolDown
            equal expected result
        test "SHOULD be true WHEN has ammo AND not cooling down" do
            let 
                shotCount = 1
                shotCoolDown = 0

                expected = true 

                result = canFire $ buildShotgun shotCount shotCoolDown
            equal expected result

buildShotgun :: Int -> Int -> Shotgun
buildShotgun shotCount shotCoolDown = p
    where 
        basic = defaultShotgun { x: 0, y: 0 } 0
        p = basic { 
            shotCount = shotCount,
            shotCoolDown = shotCoolDown 
        }