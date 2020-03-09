module Test.Revoked.Data.Enemy.Marine ( 
    marineTests 
) where

import Prelude

import Test.Unit (TestSuite)

import Test.Revoked.Data.Enemy.Marine.PlayerInRange (playerInRangeTests)
import Test.Revoked.Data.Enemy.Marine.AdjustVelocity (adjustVelocityTests)

marineTests :: TestSuite
marineTests = do
    playerInRangeTests
    adjustVelocityTests