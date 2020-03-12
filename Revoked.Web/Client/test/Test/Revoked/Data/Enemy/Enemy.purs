module Test.Revoked.Data.Enemy ( 
    enemyTests 
) where

import Prelude

import Test.Unit (TestSuite)

import Test.Revoked.Data.Enemy.Marine (marineTests)
import Test.Revoked.Data.Enemy.BigBertha (bigBerthaTests)

enemyTests :: TestSuite
enemyTests = do
    marineTests
    bigBerthaTests