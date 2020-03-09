module Test.Revoked.Data.Enemy.BigBertha.TransitionPhase ( 
    transitionPhaseTests 
) where

import Prelude

import Revoked.Data.Enemy.BigBertha (transitionPhase, phase2, phase1, defaultBigBertha, Phase(..))
import Revoked.Constants (bigBerthaImmunityCooldown)
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)

transitionPhaseTests :: TestSuite
transitionPhaseTests =
    suite "Revoked.Data.Enemy.BigBertha - transitionPhase" do
        test "SHOULD transition phase AND become immune WHEN at health gate AND not immune" do
            let 
                leftLimit = {  x: 0, y: 5 }
                rightLimit = { x: 15, y: 5 } 
                pos = { x: 10, y: 5 }
                immuneCooldown = 0
                bertha = (defaultBigBertha leftLimit rightLimit) {
                    health = 10,
                    immuneCooldown = 0
                }

                expectedPhase = phase2 pos leftLimit rightLimit
                expectedImmuneCooldown = bigBerthaImmunityCooldown

                result = transitionPhase bertha
            equal 10 result.health
            equal true $ phaseEqual expectedPhase result.phase
            equal expectedImmuneCooldown result.immuneCooldown    
        test "SHOULD not transition phase WHEN not at health gate" do
            let 
                leftLimit = {  x: 0, y: 5 }
                rightLimit = { x: 15, y: 5 } 
                pos = { x: 10, y: 5 }
                immuneCooldown = 0
                bertha = (defaultBigBertha leftLimit rightLimit) {
                    health = 11,
                    immuneCooldown = 0
                }

                expectedPhase = phase1 pos leftLimit rightLimit
                expectedImmuneCooldown = 0

                result = transitionPhase bertha
            equal 11 result.health
            equal true $ phaseEqual expectedPhase result.phase
            equal expectedImmuneCooldown result.immuneCooldown  

phaseEqual :: Phase -> Phase -> Boolean
phaseEqual (Phase1 _) (Phase1 _) = true 
phaseEqual (Phase2 _) (Phase2 _) = true 
phaseEqual (Phase3 _) (Phase3 _) = true 
phaseEqual _ _ = false