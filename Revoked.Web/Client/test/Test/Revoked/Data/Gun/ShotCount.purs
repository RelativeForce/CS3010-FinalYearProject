module Test.Revoked.Data.Gun.ShotCount ( 
    shotCountTests 
) where

import Prelude

import Data.Gun (shotCount, defaultPistolGun, defaultShotgunGun, defaultAssaultRifleGun, defaultBlasterGun)
import Constants (maxShotCount, shotgunMagazineSize, assaultRifleMagazineSize)
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)

shotCountTests :: TestSuite
shotCountTests =
    suite "Revoked.Data.Gun - shotCount" do
        test "SHOULD be max shot count WHEN gun is default blaster" do
            let 
                gun = defaultBlasterGun { x: 0, y: 0 } 0

                expected = maxShotCount 

                result = shotCount gun
            equal expected result
        test "SHOULD be default magazine size WHEN gun is default shotgun" do
            let 
                gun = defaultShotgunGun { x: 0, y: 0 } 0

                expected = shotgunMagazineSize 

                result = shotCount gun
            equal expected result
        test "SHOULD be default magazine size WHEN gun is default assualt rifle" do
            let 
                gun = defaultAssaultRifleGun { x: 0, y: 0 } 0

                expected = assaultRifleMagazineSize 

                result = shotCount gun
            equal expected result
        test "SHOULD be max shot count WHEN gun is default pistol" do
            let 
                gun = defaultPistolGun { x: 0, y: 0 } 0

                expected = maxShotCount 

                result = shotCount gun
            equal expected result