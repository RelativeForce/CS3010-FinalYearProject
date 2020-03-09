module Test.Revoked.Data.Goal ( 
    goalTests 
) where

import Prelude

import Test.Unit (TestSuite)

import Test.Revoked.Data.Goal.MapToHealth (mapToHealthTests)
import Test.Revoked.Data.Goal.IsNextLevelGoal (isNextLevelGoalTests)
import Test.Revoked.Data.Goal.IsGunGoal (isGunGoalTests)
import Test.Revoked.Data.Goal.MapToGun (mapToGunTests)
import Test.Revoked.Data.Goal.ToHealthBonus (toHealthBonusTests)
import Test.Revoked.Data.Goal.FirstGun (firstGunTests)

goalTests :: TestSuite
goalTests = do
    mapToHealthTests
    isNextLevelGoalTests
    isGunGoalTests
    mapToGunTests
    toHealthBonusTests
    firstGunTests
