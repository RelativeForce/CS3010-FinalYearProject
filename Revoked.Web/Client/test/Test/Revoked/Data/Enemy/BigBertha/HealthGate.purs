module Test.Revoked.Data.Enemy.BigBertha.HealthGate ( 
    healthGateTests 
) where

import Prelude

import Data.Enemy.BigBertha (phase1, phase2, phase3, healthGate)
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)

healthGateTests :: TestSuite
healthGateTests =
    suite "Revoked.Data.Enemy.BigBertha - healthGate" do
        test "healthGateIs10GivenPhase1" do
            let 
                leftLimit = {  x: 0, y: 5 }
                rightLimit = { x: 15, y: 5 } 
                pos = { x: 10, y: 5 }
                expected = 10
                phase = phase1 pos leftLimit rightLimit

                result = healthGate phase
            equal expected result  
        test "healthGateIs5GivenPhase2" do
            let 
                leftLimit = {  x: 0, y: 5 }
                rightLimit = { x: 15, y: 5 } 
                pos = { x: 10, y: 5 }
                expected = 5
                phase = phase2 pos leftLimit rightLimit

                result = healthGate phase
            equal expected result   
        test "healthGateIsZeroGivenPhase3" do
            let 
                leftLimit = {  x: 0, y: 5 }
                rightLimit = { x: 15, y: 5 } 
                pos = { x: 10, y: 5 }
                expected = 0
                phase = phase3 pos leftLimit rightLimit

                result = healthGate phase
            equal expected result  
