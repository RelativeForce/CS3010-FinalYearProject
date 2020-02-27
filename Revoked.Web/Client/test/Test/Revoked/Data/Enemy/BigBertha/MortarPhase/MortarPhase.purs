module Test.Revoked.Data.Enemy.BigBertha.MortarPhase ( 
    mortarPhaseTests 
) where

import Prelude

import Effect (Effect)
import Test.Revoked.Data.Enemy.BigBertha.MortarPhase.DefaultMortarPhase (defaultMortarPhaseTests)
import Test.Unit.Main (runTest)

mortarPhaseTests :: Effect Unit
mortarPhaseTests = do
    -- Sub Modules

    -- Tests
    runTest do
        defaultMortarPhaseTests
    