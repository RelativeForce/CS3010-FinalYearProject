module Test.Revoked.Data ( 
    dataTests 
) where

import Prelude

import Test.Unit (TestSuite)

import Test.Revoked.Data.Player (playerTests)
import Test.Revoked.Data.Enemy (enemyTests)
import Test.Revoked.Data.Gun (gunTests)
import Test.Revoked.Data.Bullet (bulletTests)
import Test.Revoked.Data.Goal (goalTests)
import Test.Revoked.Data.Helper (helperTests)

dataTests :: TestSuite
dataTests = do
    playerTests
    helperTests
    enemyTests
    gunTests
    bulletTests
    goalTests