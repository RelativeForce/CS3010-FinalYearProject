module Test.Revoked.Data.Enemy.BigBertha.Helper.CoolDownShot ( 
    coolDownShotTests 
) where

import Prelude

import Data.Enemy.BigBertha.Helper (coolDownShot)
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)

coolDownShotTests :: TestSuite
coolDownShotTests =
    suite "Revoked.Data.Enemy.BigBertha.Helper - coolDownShot" do
        test "SHOULD be 9 WHEN cooldown is 10" do
            let 
                cooldown = 10

                expected = 9

                result = coolDownShot cooldown
            equal expected result
        test "SHOULD be 0 WHEN cooldown is 0" do
            let 
                cooldown = 0

                expected = 0

                result = coolDownShot cooldown
            equal expected result
        test "SHOULD be 0 WHEN cooldown is 1" do
            let 
                cooldown = 1

                expected = 0

                result = coolDownShot cooldown
            equal expected result

