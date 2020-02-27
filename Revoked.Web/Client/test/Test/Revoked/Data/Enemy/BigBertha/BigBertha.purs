module Test.Revoked.Data.Enemy.BigBertha ( 
    bigBerthaTests 
) where

import Prelude

import Effect (Effect)

-- Sub Modules
import Test.Revoked.Data.Enemy.BigBertha.MortarPhase (mortarPhaseTests)

-- Tests
import Test.Revoked.Data.Enemy.BigBertha.DefaultBigBertha (defaultBigBerthaTests)
import Test.Revoked.Data.Enemy.BigBertha.IsImmune (isImmuneTests)
import Test.Revoked.Data.Enemy.BigBertha.HealthGate (healthGateTests)
import Test.Revoked.Data.Enemy.BigBertha.NextPhase (nextPhaseTests)
import Test.Revoked.Data.Enemy.BigBertha.DamageBigBertha (damageBigBerthaTests)
import Test.Revoked.Data.Enemy.BigBertha.TransitionPhase (transitionPhaseTests)
import Test.Unit.Main (runTest)

bigBerthaTests :: Effect Unit
bigBerthaTests = do
    -- Sub Modules
    mortarPhaseTests

    -- Tests
    runTest do
        defaultBigBerthaTests
        isImmuneTests
        healthGateTests
        nextPhaseTests
        damageBigBerthaTests
        transitionPhaseTests
    