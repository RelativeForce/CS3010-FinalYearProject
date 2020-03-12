module Test.Revoked.Data.Enemy.BigBertha.CannonPhase ( 
    cannonPhaseTests 
) where

import Prelude

import Test.Unit (TestSuite)

import Test.Revoked.Data.Enemy.BigBertha.CannonPhase.DefaultCannonPhase (defaultCannonPhaseTests)
import Test.Revoked.Data.Enemy.BigBertha.CannonPhase.UpdateCannonPhase (updateCannonPhaseTests)

cannonPhaseTests :: TestSuite
cannonPhaseTests = do
    defaultCannonPhaseTests
    updateCannonPhaseTests
    