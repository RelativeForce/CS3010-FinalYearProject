module Test.Revoked.Data.Enemy.BigBertha.NextPhase ( 
    nextPhaseTests 
) where

import Prelude

import Revoked.Data.Enemy.BigBertha (phase1, phase2, phase3, nextPhase, Phase(..))
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)

nextPhaseTests :: TestSuite
nextPhaseTests =
    suite "Revoked.Data.Enemy.BigBertha - nextPhase" do
        test "SHOULD be phase 2 WHEN given phase 1" do
            let 
                leftLimit = {  x: 0, y: 5 }
                rightLimit = { x: 15, y: 5 } 
                pos = { x: 10, y: 5 }
                expected = phase2 pos leftLimit rightLimit
                phase = phase1 pos leftLimit rightLimit

                result = nextPhase phase
            equal true $ phaseEqual expected result  
        test "SHOULD be phase 3 WHEN given phase 2" do
            let 
                leftLimit = {  x: 0, y: 5 }
                rightLimit = { x: 15, y: 5 } 
                pos = { x: 10, y: 5 }
                expected = phase3 pos leftLimit rightLimit
                phase = phase2 pos leftLimit rightLimit

                result = nextPhase phase
            equal true $ phaseEqual expected result   
        test "SHOULD be phase 1 WHEN given phase 3" do
            let 
                leftLimit = {  x: 0, y: 5 }
                rightLimit = { x: 15, y: 5 } 
                pos = { x: 10, y: 5 }
                expected = phase1 pos leftLimit rightLimit
                phase = phase3 pos leftLimit rightLimit

                result = nextPhase phase
            equal true $ phaseEqual expected result  

phaseEqual :: Phase -> Phase -> Boolean
phaseEqual (Phase1 _) (Phase1 _) = true 
phaseEqual (Phase2 _) (Phase2 _) = true 
phaseEqual (Phase3 _) (Phase3 _) = true 
phaseEqual _ _ = false