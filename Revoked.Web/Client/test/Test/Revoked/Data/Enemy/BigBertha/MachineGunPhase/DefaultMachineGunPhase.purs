module Test.Revoked.Data.Enemy.BigBertha.MachineGunPhase.DefaultMachineGunPhase ( 
    defaultMachineGunPhaseTests 
) where

import Prelude

import Data.Enemy.BigBertha.MachineGunPhase (defaultMachineGunPhase)
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)

defaultMachineGunPhaseTests :: TestSuite
defaultMachineGunPhaseTests =
    suite "Revoked.Data.Enemy.BigBertha.MachineGunPhase - defaultMachineGunPhase" do
        test "SHOULD have expected default state" do
            let 
                leftLimit = {  x: 0, y: 5 }
                rightLimit = { x: 15, y: 5 } 
                pos = { x: 4, y: 5 } 

                expectedPos = pos
                expectedLeftLimit = leftLimit
                expectedRightLimit = rightLimit

                result = defaultMachineGunPhase pos leftLimit rightLimit
            equal expectedPos result.pos    
            equal expectedLeftLimit result.leftLimit    
            equal expectedRightLimit result.rightLimit
        test "SHOULD swap left limit with right limit WHEN left x > right x" do
            let 
                leftLimit = {  x: 15, y: 5 }
                rightLimit = { x: 0, y: 5 } 
                pos = { x: 4, y: 5 } 

                expectedPos = pos
                expectedLeftLimit = rightLimit
                expectedRightLimit = leftLimit

                result = defaultMachineGunPhase pos leftLimit rightLimit
            equal expectedPos result.pos    
            equal expectedLeftLimit result.leftLimit    
            equal expectedRightLimit result.rightLimit      
