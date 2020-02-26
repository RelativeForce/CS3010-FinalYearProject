module Test.Revoked.Data.Gun.Pistol.CanFire ( 
    canFireTests 
) where

import Prelude

import Data.Gun.Pistol (Pistol, canFire, defaultPistol)
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)

canFireTests :: TestSuite
canFireTests =
    suite "Revoked.Data.Gun.Pistol - canFire" do
        test "canNotFireWhenOutOfAmmoAndNotInfiniteAmmo" do
            let 
                isInfinite = false
                shotCount = 0
                shotCoolDown = 0

                expected = false 

                result = canFire $ buildPistol isInfinite shotCount shotCoolDown
            equal expected result
        test "canNotFireWhenCoolingDownAndNotInfiniteAmmo" do
            let 
                isInfinite = false
                shotCount = 1
                shotCoolDown = 1

                expected = false 

                result = canFire $ buildPistol isInfinite shotCount shotCoolDown
            equal expected result
        test "canFireWhenHasAmmoAndNotCoolingDownAndNotInfiniteAmmo" do
            let 
                isInfinite = false
                shotCount = 1
                shotCoolDown = 0

                expected = true 

                result = canFire $ buildPistol isInfinite shotCount shotCoolDown
            equal expected result
        test "canNotFireWhenCoolingDownAndInfiniteAmmo" do
            let 
                isInfinite = true
                shotCount = 1
                shotCoolDown = 1

                expected = false 

                result = canFire $ buildPistol isInfinite shotCount shotCoolDown
            equal expected result
        test "canFireWhenHasNoAmmoAndNotCoolingDownAndInfiniteAmmo" do
            let 
                isInfinite = true
                shotCount = 1
                shotCoolDown = 0

                expected = true 

                result = canFire $ buildPistol isInfinite shotCount shotCoolDown
            equal expected result

buildPistol :: Boolean -> Int -> Int -> Pistol
buildPistol isInfinite shotCount shotCoolDown = p
    where 
        basic = defaultPistol isInfinite { x: 0, y: 0 } 0
        p = basic { 
            shotCount = shotCount,
            shotCoolDown = shotCoolDown 
        }