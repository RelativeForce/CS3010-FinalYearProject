module Test.Revoked.Data.Player.CanFire ( 
    canFireTests 
) where

import Prelude
import Data.Player (canFire)
import Test.Unit (TestSuite, suite, test)
import Constants (playerShotCooldown)
import Test.Unit.Assert (equal)

canFireTests :: TestSuite
canFireTests =
    suite "Revoked.Data.Player - canFire" do
        test "canFireWhenEnergyIsAtMax" do
            let 
                currentEnergy = playerShotCooldown
                expected = true

                result = canFire currentEnergy
            equal expected result
        test "canFireWhenEnergyIsAboveMax" do
            let 
                currentEnergy = playerShotCooldown + 20
                expected = true

                result = canFire currentEnergy
            equal expected result
        test "canNotFireWhenEnergyIsAtZero" do
            let 
                currentEnergy = 0
                expected = false

                result = canFire currentEnergy
            equal expected result
