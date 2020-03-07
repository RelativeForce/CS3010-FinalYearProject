module Test.Revoked.Data.Enemy.BigBertha.MortarPhase ( 
    mortarPhaseTests 
) where

import Prelude

import Test.Revoked.Data.Enemy.BigBertha.MortarPhase.DefaultMortarPhase (defaultMortarPhaseTests)
import Test.Revoked.Data.Enemy.BigBertha.MortarPhase.VerticalVelocity (verticalVelocityTests)
import Test.Revoked.Data.Enemy.BigBertha.MortarPhase.HorizontalVelocity (horizontalVelocityTests)
import Test.Revoked.Data.Enemy.BigBertha.MortarPhase.UpdateMortarPhase (updateMortarPhaseTests)
import Test.Unit (TestSuite)

mortarPhaseTests :: TestSuite
mortarPhaseTests = do
    defaultMortarPhaseTests
    horizontalVelocityTests
    verticalVelocityTests
    updateMortarPhaseTests
    