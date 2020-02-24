module Test.Revoked.Data.Enemy.BigBertha.DamageBigBertha ( 
    damageBigBerthaTests 
) where

import Prelude

import Data.Enemy.BigBertha (phase1, phase2, phase3, damageBigBertha, healthGate, defaultBigBertha)
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)

damageBigBerthaTests :: TestSuite
damageBigBerthaTests =
    suite "Revoked.Data.Enemy.BigBertha - damageBigBertha" do
        test "shouldDealDamageWhenNOTImmuneAndDamageDoesNotEncounterHealthGate" do
            let 
                leftLimit = {  x: 0, y: 5 }
                rightLimit = { x: 15, y: 5 } 
                pos = { x: 10, y: 5 }
                immuneCooldown = 0
                damage = 2
                bertha = defaultBigBertha leftLimit rightLimit

                expected = bertha.health - damage

                result = damageBigBertha bertha damage
            equal expected result.health   
        test "shouldDealDamageUptoHealthGateWhenNOTImmuneAndDamageWouldResultInLowerHealthThenHealthGate" do
            let 
                leftLimit = {  x: 0, y: 5 }
                rightLimit = { x: 15, y: 5 } 
                pos = { x: 10, y: 5 }
                immuneCooldown = 0
                damage = 6
                bertha = defaultBigBertha leftLimit rightLimit
                initialHealth = bertha.health 
                gate = healthGate bertha.phase

                expected = gate

                result = damageBigBertha bertha damage
            equal expected result.health
        test "shouldNOTDealDamageWhenImmune" do
            let 
                leftLimit = {  x: 0, y: 5 }
                rightLimit = { x: 15, y: 5 } 
                pos = { x: 10, y: 5 }
                immuneCooldown = 1
                damage = 6
                bertha = (defaultBigBertha leftLimit rightLimit) {
                    immuneCooldown = immuneCooldown
                }

                initialHealth = bertha.health 
                gate = healthGate bertha.phase

                expected = initialHealth

                result = damageBigBertha bertha damage
            equal expected result.health    