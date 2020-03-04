module Test.Revoked.Data.Enemy.Marine ( 
    marineTests 
) where

import Prelude

import Test.Revoked.Data.Enemy.Marine.PlayerInRange (playerInRangeTests)
import Test.Revoked.Data.Enemy.Marine.AdjustVelocity (adjustVelocityTests)
import Test.Unit (TestSuite)

marineTests :: TestSuite
marineTests = do
    playerInRangeTests
    adjustVelocityTests