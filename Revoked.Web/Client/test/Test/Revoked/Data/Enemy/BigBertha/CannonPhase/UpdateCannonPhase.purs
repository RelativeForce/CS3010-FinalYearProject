module Test.Revoked.Data.Enemy.BigBertha.CannonPhase.UpdateCannonPhase ( 
    updateCannonPhaseTests 
) where

import Prelude

import Revoked.Constants (bigBerthaSpeed, bigBerthaCannonPhaseShotCooldown)
import Data.Enemy.BigBertha.CannonPhase (CannonPhase, updateCannonPhase, defaultCannonPhase)
import Revoked.Data.Player (initialPlayer)
import Data.Int (floor)
import Data.Array (length)
import Emo8.Types (Position)
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)

updateCannonPhaseTests :: TestSuite
updateCannonPhaseTests =
    suite "Revoked.Data.Enemy.BigBertha.CannonPhase - updateCannonPhase" do
        test "SHOULD move but not fire WHEN ShotCooldown > 0 AND player is in range" do
            let 
                shotCoolDown = 1
                mortarPos = { x: 100, y: 40 }
                phase = (buildDefaultCannonPhase mortarPos) {
                    shotCoolDown = shotCoolDown
                }
                distance = 0
                player = initialPlayer { x: 0, y: 0 }

                expectedPos = { x: mortarPos.x - (floor bigBerthaSpeed), y: mortarPos.y }
                expectedShotCoolDown = 0

                { phase: resultPhase, bullets: resultBullets } = updateCannonPhase distance player phase
            equal expectedPos resultPhase.pos
            equal expectedShotCoolDown resultPhase.shotCoolDown
        test "SHOULD move AND fire WHEN ShotCooldown is 0 AND player is in range" do
            let 
                shotCoolDown = 0
                mortarPos = { x: 100, y: 40 }
                phase = (buildDefaultCannonPhase mortarPos) {
                    shotCoolDown = shotCoolDown
                }
                distance = 0
                player = initialPlayer { x: 0, y: 0 }

                expectedPos = { x: mortarPos.x - (floor bigBerthaSpeed), y: mortarPos.y }
                expectedShotCoolDown = bigBerthaCannonPhaseShotCooldown
                expectedNumberOfBullets = 5

                { phase: resultPhase, bullets: resultBullets } = updateCannonPhase distance player phase
            equal expectedPos resultPhase.pos
            equal expectedShotCoolDown resultPhase.shotCoolDown
            equal expectedNumberOfBullets (length resultBullets)

buildDefaultCannonPhase :: Position -> CannonPhase  
buildDefaultCannonPhase pos = defaultCannonPhase pos leftLimit rightLimit
    where
        leftLimit = { x: pos.x - 50, y: pos.y }
        rightLimit = { x: pos.x + 50, y: pos.y }

