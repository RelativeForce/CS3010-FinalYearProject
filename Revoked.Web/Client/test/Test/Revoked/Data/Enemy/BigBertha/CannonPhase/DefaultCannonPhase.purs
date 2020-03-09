module Test.Revoked.Data.Enemy.BigBertha.CannonPhase.DefaultCannonPhase ( 
    defaultCannonPhaseTests 
) where

import Prelude

import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)

import Revoked.Data.Enemy.BigBertha.CannonPhase (defaultCannonPhase)

defaultCannonPhaseTests :: TestSuite
defaultCannonPhaseTests =
    suite "Revoked.Data.Enemy.BigBertha.CannonPhase - defaultCannonPhase" do
        test "SHOULD have expected default state" do
            let 
                leftLimit = {  x: 0, y: 5 }
                rightLimit = { x: 15, y: 5 } 
                pos = { x: 4, y: 5 } 

                expectedPos = pos
                expectedLeftLimit = leftLimit
                expectedRightLimit = rightLimit

                result = defaultCannonPhase pos leftLimit rightLimit
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

                result = defaultCannonPhase pos leftLimit rightLimit
            equal expectedPos result.pos    
            equal expectedLeftLimit result.leftLimit    
            equal expectedRightLimit result.rightLimit      
