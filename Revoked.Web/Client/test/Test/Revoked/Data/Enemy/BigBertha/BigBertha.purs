module Test.Revoked.Data.Enemy.BigBertha ( 
    bigBerthaTests 
) where

import Prelude

import Effect (Effect)
import Test.Revoked.Data.Enemy.BigBertha.DefaultBigBertha (defaultBigBerthaTests)
import Test.Revoked.Data.Enemy.BigBertha.IsImmune (isImmuneTests)
import Test.Revoked.Data.Enemy.BigBertha.HealthGate (healthGateTests)
import Test.Revoked.Data.Enemy.BigBertha.NextPhase (nextPhaseTests)
import Test.Revoked.Data.Enemy.BigBertha.DamageBigBertha (damageBigBerthaTests)
import Test.Unit.Main (runTest)

bigBerthaTests :: Effect Unit
bigBerthaTests = do
    -- Sub Modules

    -- Tests
    runTest do
        defaultBigBerthaTests
        isImmuneTests
        healthGateTests
        nextPhaseTests
        damageBigBerthaTests
    