module Revoked.Data.Enemy.BigBertha where

import Prelude

import Emo8.Types (Position, X, Sprite, Size)
import Emo8.Data.Sprite (incrementFrame)
import Emo8.Class.Object (class Object)

import Revoked.Assets.Sprites as S
import Revoked.Data.Bullet (Bullet)
import Revoked.Data.Player (Player)
import Revoked.Constants (bigBerthaImmunityCooldown)
import Revoked.Data.Enemy.BigBertha.MortarPhase (MortarPhase, updateMortarPhase, defaultMortarPhase)
import Revoked.Data.Enemy.BigBertha.MachineGunPhase (MachineGunPhase, updateMachineGunPhase, defaultMachineGunPhase)
import Revoked.Data.Enemy.BigBertha.CannonPhase (CannonPhase, updateCannonPhase, defaultCannonPhase)

-- | Wraps the different Phases that BigBertha transitions between.
data Phase = 
    Phase1 MortarPhase | 
    Phase2 MachineGunPhase | 
    Phase3 CannonPhase

-- | Represents the state of BigBertha
type BigBertha = { 
    health :: Int,
    phase :: Phase,
    sprite :: Sprite,
    immuneCooldown :: Int
}

instance objectPhase :: Object Phase where
    size (Phase1 s) = spriteSize
    size (Phase2 s) = spriteSize
    size (Phase3 s) = spriteSize
    position (Phase1 s) = s.pos
    position (Phase2 s) = s.pos
    position (Phase3 s) = s.pos
    scroll offset (Phase1 s) = Phase1 $ s { pos = { x: s.pos.x + offset, y: s.pos.y } }
    scroll offset (Phase2 s) = Phase2 $ s { pos = { x: s.pos.x + offset, y: s.pos.y } }
    scroll offset (Phase3 s) = Phase3 $ s { pos = { x: s.pos.x + offset, y: s.pos.y } }

-- | Transitions the specified BigBertha into its next phase based on its 
-- | health and current damage immunity.
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

-- | Retreieves whether the specified BigBertha is immune to damage or not.
isImmune :: BigBertha -> Boolean
isImmune bb = bb.immuneCooldown > 0

-- | Inflicts a specified amount of damage to BigBertha.
damageBigBertha :: BigBertha -> Int -> BigBertha
damageBigBertha bb healthLoss = bb { health = newHealth }
    where  
        hg = healthGate bb.phase
        damageAppliedHealth = (bb.health - healthLoss)
        newHealth = if isImmune bb 
            then bb.health 
            else if damageAppliedHealth < hg 
                then hg 
                else damageAppliedHealth

-- | Whether or not the specified BigBertha should transition or not based 
-- | on its helath.
shouldTransition :: BigBertha -> Boolean
shouldTransition bb = bb.health == healthGate bb.phase

-- | Retrieves the remaining health that should trigger BigBertha to 
-- | transition into the next phase. The last phase should allways have a 
-- | health gates of zero.
healthGate :: Phase -> Int
healthGate (Phase1 _) = 10
healthGate (Phase2 _) = 5
healthGate (Phase3 _) = 0

-- | Retrives the next Phase for the specified Phase. The last phase should build the first causing a cycle 
-- | even though when BigBertha transitions out of the last phase it should have zero health and thus die. 
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

-- | Updates the specified BigBertha based on the position of the player and retreives the bullets 
-- | fired by the BigBertha.
updateBigBertha :: X -> Player -> BigBertha -> { enemy :: BigBertha, bullets :: Array Bullet }
updateBigBertha distance p bigBertha = { enemy: newBigBertha, bullets: newBullets } 
    where
        -- Update the phase and retrive the bullets fired
        { phase: updatedPhase, bullets: newBullets } = updatePhase distance p bigBertha.phase

        -- Transition to the next phase if required by health 
        phaseTransitionedBigBertha = transitionPhase $ bigBertha { phase = updatedPhase }

        -- Check immunity
        oldImmunity = (isImmune bigBertha)
        newImmunity = (isImmune phaseTransitionedBigBertha)
        immunityChanged = oldImmunity /= newImmunity

        -- Update sprite based on immunity
        newBigBertha = phaseTransitionedBigBertha {
            sprite = if immunityChanged then spriteBasedOnImmunity newImmunity else incrementFrame bigBertha.sprite 
        }

-- | Retrieves the new sprite based on the specified immunity status.
spriteBasedOnImmunity :: Boolean -> Sprite
spriteBasedOnImmunity immunity = if immunity then S.bigBerthaImmune else S.bigBerthaNormal

-- | Decreases the specified immunity until it reaches zero. Then it stays at zero.
coolDownImmunity :: Int -> Int
coolDownImmunity immunity = if (immunity - 1) < 0 then 0 else immunity - 1

-- | Updates the specified phase based on the position of the player and retreives the bullets 
-- | fired by the phase.
updatePhase :: X -> Player -> Phase -> { phase :: Phase, bullets :: Array Bullet }
updatePhase distance p (Phase1 mortarPhase) = toPhaseAndBullets (Phase1) (updateMortarPhase distance p mortarPhase)
updatePhase distance p (Phase2 machineGunPhase) = toPhaseAndBullets (Phase2) (updateMachineGunPhase distance p machineGunPhase)
updatePhase distance p (Phase3 cannonPhase) = toPhaseAndBullets (Phase3) (updateCannonPhase distance p cannonPhase)

-- | Maps any type of Phase and bullets pair into a Phase and bullets pair using the specified mapper function. 
toPhaseAndBullets :: forall a. (a -> Phase) -> { phase :: a, bullets :: Array Bullet } -> { phase :: Phase, bullets :: Array Bullet }
toPhaseAndBullets mapper r = { phase: mapper r.phase, bullets: r.bullets }

-- | The size of BigBertha 
spriteSize :: Size
spriteSize = S.bigBerthaNormal.size

-- | Builds a BigBertha with a specified left and right `Position`.
defaultBigBertha :: Position -> Position -> BigBertha
defaultBigBertha leftLimit rightLimit = {
    phase: phase1 rightLimit leftLimit rightLimit,
    health: 15,
    sprite: S.bigBerthaNormal,
    immuneCooldown: 0
}