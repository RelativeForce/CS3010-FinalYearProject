module Test.Revoked.Data.Gun.Blaster.CanFire ( 
    canFireTests 
) where

import Prelude

import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)

import Revoked.Data.Gun.Blaster (Blaster, canFire, defaultBlaster)

canFireTests :: TestSuite
canFireTests =
    suite "Revoked.Data.Gun.Blaster - canFire" do
        test "SHOULD be false WHEN cooling down" do
            let 
                shotCoolDown = 1

                expected = false 

                result = canFire $ buildBlaster shotCoolDown
            equal expected result
        test "SHOULD be true WHEN not cooling down" do
            let 
                shotCoolDown = 0

                expected = true 

                result = canFire $ buildBlaster shotCoolDown
            equal expected result

buildBlaster :: Int -> Blaster
buildBlaster shotCoolDown = p
    where 
        basic = defaultBlaster { x: 0, y: 0 } 0
        p = basic { shotCoolDown = shotCoolDown }