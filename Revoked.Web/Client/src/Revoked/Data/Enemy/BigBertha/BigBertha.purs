module Data.Enemy.BigBertha where

import Prelude

import Data.Bullet (Bullet)
import Data.Player (Player)
import Emo8.Types (Position)
import Data.Enemy.BigBertha.MortarPhase (MortarPhase, updateMortarPhase, defaultMortarPhase)

data Phase = 
    Phase1 MortarPhase | 
    Phase2 Int | 
    Phase3 Int

type BigBertha = { 
    health :: Int,
    phase :: Phase,
    immuneCooldown :: Int
}

transitionPhase :: BigBertha -> BigBertha
transitionPhase bb = bb { phase = phase, immuneCooldown = immuneCooldown }
    where
        goToNext = shouldTransition bb  
        phase = if goToNext then nextPhase bb.phase else bb.phase
        immuneCooldown = if goToNext then 60 else bb.immuneCooldown

isImmune :: BigBertha -> Boolean
isImmune bb = bb.immuneCooldown <= 0

damageBigBertha :: BigBertha -> Int -> BigBertha
damageBigBertha bb healthLoss = bb { health = newHealth }
    where  
        hg = healthGate bb.phase
        damageAppliedHealth = (bb.health - healthLoss)
        newHealth = if damageAppliedHealth < hg then hg else damageAppliedHealth

shouldTransition :: BigBertha -> Boolean
shouldTransition bb = isAtHealthGate && noImmuneCooldown
    where
        isAtHealthGate = bb.health == healthGate bb.phase
        noImmuneCooldown = not $ isImmune bb

healthGate :: Phase -> Int
healthGate (Phase1 _) = 10
healthGate (Phase2 _) = 5
healthGate (Phase3 _) = 0

nextPhase :: Phase -> Phase
nextPhase (Phase1 p) = phase2
nextPhase _ = phase3

phase1 :: Position -> Position -> Phase
phase1 leftLimit rightLimit = Phase1 $ defaultMortarPhase leftLimit rightLimit

phase2 :: Phase
phase2 = Phase2 0

phase3 :: Phase
phase3 = Phase3 1

updateBigBertha :: Player -> BigBertha -> { enemy :: BigBertha, bullets :: Array Bullet }
updateBigBertha p bigBertha = { enemy: newBigBertha, bullets: newBullets } 
    where
        { phase: updatedPhase, bullets: newBullets } = updatePhase p bigBertha.phase
        newPhase = if shouldTransition bigBertha
            then nextPhase bigBertha.phase 
            else updatedPhase
        newBigBertha = bigBertha {
            immuneCooldown = if (bigBertha.immuneCooldown - 1 < 0) then bigBertha.immuneCooldown - 1 else 0,
            phase = newPhase
        }

updatePhase :: Player -> Phase -> { phase :: Phase, bullets :: Array Bullet }
updatePhase p (Phase1 mortarPhase) = toPhaseAndBullets (Phase1) (updateMortarPhase p mortarPhase)
updatePhase p (Phase2 a) = { phase: Phase2 a, bullets: [] }
updatePhase p (Phase3 b) = { phase: Phase3 b, bullets: [] }

toPhaseAndBullets :: forall a. (a -> Phase) -> { phase :: a, bullets :: Array Bullet } -> { phase :: Phase, bullets :: Array Bullet }
toPhaseAndBullets mapper r = { phase: mapper r.phase, bullets: r.bullets }

defaultBigBertha :: Int -> Position -> Position -> BigBertha
defaultBigBertha bigBerthaHealth leftLimit rightLimit = {
    phase: phase1 leftLimit rightLimit,
    health: bigBerthaHealth,
    immuneCooldown: 0
}
        
