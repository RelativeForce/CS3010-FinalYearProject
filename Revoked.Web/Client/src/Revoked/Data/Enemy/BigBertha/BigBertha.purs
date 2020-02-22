module Data.Enemy.BigBertha where

import Prelude

import Assets.Sprites as S
import Class.Object (class Object)
import Data.Bullet (Bullet)
import Data.Player (Player)
import Emo8.Types (Position, X, Sprite)
import Emo8.Data.Sprite (incrementFrame)
import Constants (bigBerthaImmunityCooldown)
import Data.Enemy.BigBertha.MortarPhase (MortarPhase, updateMortarPhase, defaultMortarPhase)
import Data.Enemy.BigBertha.MachineGunPhase (MachineGunPhase, updateMachineGunPhase, defaultMachineGunPhase)
import Data.Enemy.BigBertha.CannonPhase (CannonPhase, updateCannonPhase, defaultCannonPhase)

data Phase = 
    Phase1 MortarPhase | 
    Phase2 MachineGunPhase | 
    Phase3 CannonPhase

type BigBertha = { 
    health :: Int,
    phase :: Phase,
    sprite :: Sprite,
    immuneCooldown :: Int
}

instance objectPhase :: Object Phase where
    size (Phase1 s) = defaultSprite.size
    size (Phase2 s) = defaultSprite.size
    size (Phase3 s) = defaultSprite.size
    position (Phase1 s) = s.pos
    position (Phase2 s) = s.pos
    position (Phase3 s) = s.pos
    scroll offset (Phase1 s) = Phase1 $ s { pos = { x: s.pos.x + offset, y: s.pos.y } }
    scroll offset (Phase2 s) = Phase2 $ s { pos = { x: s.pos.x + offset, y: s.pos.y } }
    scroll offset (Phase3 s) = Phase3 $ s { pos = { x: s.pos.x + offset, y: s.pos.y } }

transitionPhase :: BigBertha -> BigBertha
transitionPhase bb = bb { phase = phase, immuneCooldown = immuneCooldown }
    where
        goToNext = shouldTransition bb  
        phase = if goToNext 
            then nextPhase bb.phase 
            else bb.phase
        immuneCooldown = if goToNext 
            then bigBerthaImmunityCooldown 
            else coolDownImmunity bb.immuneCooldown

isImmune :: BigBertha -> Boolean
isImmune bb = bb.immuneCooldown <= 0

damageBigBertha :: BigBertha -> Int -> BigBertha
damageBigBertha bb healthLoss = bb { health = newHealth }
    where  
        hg = healthGate bb.phase
        damageAppliedHealth = (bb.health - healthLoss)
        newHealth = if damageAppliedHealth < hg then hg else damageAppliedHealth

shouldTransition :: BigBertha -> Boolean
shouldTransition bb = bb.health == healthGate bb.phase

healthGate :: Phase -> Int
healthGate (Phase1 _) = 10
healthGate (Phase2 _) = 5
healthGate (Phase3 _) = 0

nextPhase :: Phase -> Phase
nextPhase (Phase1 p) = phase2 p.pos p.leftLimit p.rightLimit
nextPhase (Phase2 p) = phase3 p.pos p.leftLimit p.rightLimit
nextPhase (Phase3 p) = phase1 p.pos p.leftLimit p.rightLimit

phase1 :: Position -> Position -> Position -> Phase
phase1 pos leftLimit rightLimit = Phase1 $ defaultMortarPhase pos leftLimit rightLimit

phase2 :: Position -> Position -> Position -> Phase
phase2 pos leftLimit rightLimit = Phase2 $ defaultMachineGunPhase pos leftLimit rightLimit

phase3 :: Position -> Position -> Position -> Phase
phase3 pos leftLimit rightLimit = Phase3 $ defaultCannonPhase pos leftLimit rightLimit

updateBigBertha :: X -> Player -> BigBertha -> { enemy :: BigBertha, bullets :: Array Bullet }
updateBigBertha distance p bigBertha = { enemy: newBigBertha, bullets: newBullets } 
    where
        { phase: updatedPhase, bullets: newBullets } = updatePhase distance p bigBertha.phase
        newBigBertha = transitionPhase $ bigBertha { 
            phase = updatedPhase,
            sprite = incrementFrame bigBertha.sprite 
        }

coolDownImmunity :: Int -> Int
coolDownImmunity immunity = if (immunity - 1) < 0 then 0 else immunity - 1

updatePhase :: X -> Player -> Phase -> { phase :: Phase, bullets :: Array Bullet }
updatePhase distance p (Phase1 mortarPhase) = toPhaseAndBullets (Phase1) (updateMortarPhase distance p mortarPhase)
updatePhase distance p (Phase2 machineGunPhase) = toPhaseAndBullets (Phase2) (updateMachineGunPhase distance p machineGunPhase)
updatePhase distance p (Phase3 cannonPhase) = toPhaseAndBullets (Phase3) (updateCannonPhase distance p cannonPhase)

toPhaseAndBullets :: forall a. (a -> Phase) -> { phase :: a, bullets :: Array Bullet } -> { phase :: Phase, bullets :: Array Bullet }
toPhaseAndBullets mapper r = { phase: mapper r.phase, bullets: r.bullets }

defaultSprite :: Sprite
defaultSprite = S.bigBerthaNormal

defaultBigBertha :: Position -> Position -> BigBertha
defaultBigBertha leftLimit rightLimit = {
    phase: phase1 rightLimit leftLimit rightLimit,
    health: 15,
    sprite: defaultSprite,
    immuneCooldown: 0
}