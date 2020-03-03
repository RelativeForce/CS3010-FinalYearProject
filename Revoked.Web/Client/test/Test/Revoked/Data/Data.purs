module Test.Revoked.Data ( 
    dataTests 
) where

import Prelude

import Test.Revoked.Data.Player (playerTests)
import Test.Revoked.Data.Enemy (enemyTests)
import Test.Revoked.Data.Gun (gunTests)
import Test.Revoked.Data.Bullet (bulletTests)
import Test.Unit (TestSuite)

dataTests :: TestSuite
dataTests = do
    playerTests
    enemyTests
    gunTests
    bulletTests