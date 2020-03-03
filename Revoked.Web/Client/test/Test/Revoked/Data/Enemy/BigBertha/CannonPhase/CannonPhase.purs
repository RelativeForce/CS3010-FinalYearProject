module Test.Revoked.Data.Enemy.BigBertha.CannonPhase ( 
    cannonPhaseTests 
) where

import Prelude

import Test.Revoked.Data.Enemy.BigBertha.CannonPhase.DefaultCannonPhase (defaultCannonPhaseTests)
import Test.Revoked.Data.Enemy.BigBertha.CannonPhase.UpdateCannonPhase (updateCannonPhaseTests)
import Test.Unit (TestSuite)

cannonPhaseTests :: TestSuite
cannonPhaseTests = do
    defaultCannonPhaseTests
    updateCannonPhaseTests
    