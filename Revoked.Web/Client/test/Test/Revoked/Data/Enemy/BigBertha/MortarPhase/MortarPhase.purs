module Test.Revoked.Data.Enemy.BigBertha.MortarPhase ( 
    mortarPhaseTests 
) where

import Prelude

import Test.Unit (TestSuite)

import Test.Revoked.Data.Enemy.BigBertha.MortarPhase.DefaultMortarPhase (defaultMortarPhaseTests)
import Test.Revoked.Data.Enemy.BigBertha.MortarPhase.VerticalVelocity (verticalVelocityTests)
import Test.Revoked.Data.Enemy.BigBertha.MortarPhase.HorizontalVelocity (horizontalVelocityTests)
import Test.Revoked.Data.Enemy.BigBertha.MortarPhase.UpdateMortarPhase (updateMortarPhaseTests)

mortarPhaseTests :: TestSuite
mortarPhaseTests = do
    defaultMortarPhaseTests
    horizontalVelocityTests
    verticalVelocityTests
    updateMortarPhaseTests
    