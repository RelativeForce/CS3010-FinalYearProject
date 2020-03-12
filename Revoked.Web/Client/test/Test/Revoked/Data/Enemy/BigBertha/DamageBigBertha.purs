module Test.Revoked.Data.Enemy.BigBertha.DamageBigBertha ( 
    damageBigBerthaTests 
) where

import Prelude

import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)

import Revoked.Data.Enemy.BigBertha (damageBigBertha, healthGate, defaultBigBertha)

damageBigBerthaTests :: TestSuite
damageBigBerthaTests =
    suite "Revoked.Data.Enemy.BigBertha - damageBigBertha" do
        test "SHOULD deal damage WHEN not immune AND damage does not encounter a health gate" do
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
        test "SHOULD deal damage upto health gate WHEN not immune AND damage would result in lower health than the health gate" do
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
        test "SHOULD not deal damage WHEN immune" do
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