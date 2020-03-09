module Test.Revoked.Data.Enemy.BigBertha.MortarPhase.UpdateMortarPhase ( 
    updateMortarPhaseTests 
) where

import Prelude

import Revoked.Constants (bigBerthaSpeed, bigBerthaMortarPhaseShotCooldown)
import Data.Enemy.BigBertha.MortarPhase (MortarPhase, updateMortarPhase, defaultMortarPhase)
import Revoked.Data.Player (initialPlayer)
import Data.Int (floor)
import Data.Array (length)
import Emo8.Types (Position)
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)

updateMortarPhaseTests :: TestSuite
updateMortarPhaseTests =
    suite "Revoked.Data.Enemy.BigBertha.MortarPhase - updateMortarPhase" do
        test "SHOULD move but not fire WHEN ShotCooldown > 0 AND player is in range" do
            let 
                shotCoolDown = 1
                mortarPos = { x: 100, y: 40 }
                phase = (buildDefaultMortarPhase mortarPos) {
                    shotCoolDown = shotCoolDown
                }
                distance = 0
                player = initialPlayer { x: 0, y: 0 }

                expectedPos = { x: mortarPos.x - (floor bigBerthaSpeed), y: mortarPos.y }
                expectedShotCoolDown = 0

                { phase: resultPhase, bullets: resultBullets } = updateMortarPhase distance player phase
            equal expectedPos resultPhase.pos
            equal expectedShotCoolDown resultPhase.shotCoolDown
        test "SHOULD move AND fire WHEN ShotCooldown is 0 AND player is in range" do
            let 
                shotCoolDown = 0
                mortarPos = { x: 100, y: 40 }
                phase = (buildDefaultMortarPhase mortarPos) {
                    shotCoolDown = shotCoolDown
                }
                distance = 0
                player = initialPlayer { x: 0, y: 0 }

                expectedPos = { x: mortarPos.x - (floor bigBerthaSpeed), y: mortarPos.y }
                expectedShotCoolDown = bigBerthaMortarPhaseShotCooldown
                expectedNumberOfBullets = 1

                { phase: resultPhase, bullets: resultBullets } = updateMortarPhase distance player phase
            equal expectedPos resultPhase.pos
            equal expectedShotCoolDown resultPhase.shotCoolDown
            equal expectedNumberOfBullets (length resultBullets)

buildDefaultMortarPhase :: Position -> MortarPhase  
buildDefaultMortarPhase pos = defaultMortarPhase pos leftLimit rightLimit
    where
        leftLimit = { x: pos.x - 50, y: pos.y }
        rightLimit = { x: pos.x + 50, y: pos.y }

