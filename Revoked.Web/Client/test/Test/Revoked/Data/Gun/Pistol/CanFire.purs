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
        test "SHOULD be false WHEN cooling down" do
            let 
                shotCoolDown = 1

                expected = false 

                result = canFire $ buildPistol shotCoolDown
            equal expected result
        test "SHOULD be true WHEN not cooling down" do
            let 
                shotCoolDown = 0

                expected = true 

                result = canFire $ buildPistol shotCoolDown
            equal expected result

buildPistol :: Int -> Pistol
buildPistol shotCoolDown = p
    where 
        basic = defaultPistol { x: 0, y: 0 } 0
        p = basic { shotCoolDown = shotCoolDown }