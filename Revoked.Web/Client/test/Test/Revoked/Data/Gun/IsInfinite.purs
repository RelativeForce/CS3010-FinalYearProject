module Test.Revoked.Data.Gun.IsInfinite ( 
    isInfiniteTests 
) where

import Prelude

import Data.Gun (isInfinite, defaultPistolGun, defaultShotgunGun, defaultAssaultRifleGun, defaultBlasterGun)
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)

isInfiniteTests :: TestSuite
isInfiniteTests =
    suite "Revoked.Data.Gun - isInfinite" do
        test "SHOULD be true WHEN gun is blaster" do
            let 
                gun = defaultBlasterGun { x: 0, y: 0 } 0

                expected = true 

                result = isInfinite gun
            equal expected result
        test "SHOULD be false WHEN gun is shotgun" do
            let 
                gun = defaultShotgunGun { x: 0, y: 0 } 0

                expected = false 

                result = isInfinite gun
            equal expected result
        test "SHOULD be false WHEN gun is assualt rifle" do
            let 
                gun = defaultAssaultRifleGun { x: 0, y: 0 } 0

                expected = false 

                result = isInfinite gun
            equal expected result
        test "SHOULD be true WHEN gun is pistol" do
            let 
                gun = defaultPistolGun { x: 0, y: 0 } 0

                expected = true 

                result = isInfinite gun
            equal expected result