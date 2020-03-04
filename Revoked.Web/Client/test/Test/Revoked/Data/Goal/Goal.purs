module Test.Revoked.Data.Goal ( 
    goalTests 
) where

import Prelude

import Test.Revoked.Data.Goal.MapToHealth (mapToHealthTests)
import Test.Revoked.Data.Goal.IsNextLevelGoal (isNextLevelGoalTests)
import Test.Revoked.Data.Goal.IsGunGoal (isGunGoalTests)
import Test.Revoked.Data.Goal.MapToGun (mapToGunTests)
import Test.Unit (TestSuite)

goalTests :: TestSuite
goalTests = do
    mapToHealthTests
    isNextLevelGoalTests
    isGunGoalTests
    mapToGunTests
