module Test.Revoked.Data.Enemy.BigBertha ( 
    bigBerthaTests 
) where

import Prelude

import Test.Unit (TestSuite)

-- Sub Modules
import Test.Revoked.Data.Enemy.BigBertha.MortarPhase (mortarPhaseTests)
import Test.Revoked.Data.Enemy.BigBertha.Helper (helperTests)
import Test.Revoked.Data.Enemy.BigBertha.MachineGunPhase (machineGunPhaseTests)

-- Tests
import Test.Revoked.Data.Enemy.BigBertha.DefaultBigBertha (defaultBigBerthaTests)
import Test.Revoked.Data.Enemy.BigBertha.IsImmune (isImmuneTests)
import Test.Revoked.Data.Enemy.BigBertha.HealthGate (healthGateTests)
import Test.Revoked.Data.Enemy.BigBertha.NextPhase (nextPhaseTests)
import Test.Revoked.Data.Enemy.BigBertha.DamageBigBertha (damageBigBerthaTests)
import Test.Revoked.Data.Enemy.BigBertha.TransitionPhase (transitionPhaseTests)

bigBerthaTests :: TestSuite
bigBerthaTests = do
    mortarPhaseTests
    machineGunPhaseTests
    helperTests
    defaultBigBerthaTests
    isImmuneTests
    healthGateTests
    nextPhaseTests
    damageBigBerthaTests
    transitionPhaseTests
    