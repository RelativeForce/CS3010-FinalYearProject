module Test.Revoked ( 
    revokedTests 
) where

import Prelude

import Test.Unit (TestSuite)

import Test.Revoked.Collision (collisionTests)
import Test.Revoked.Data (dataTests)
import Test.Revoked.State (stateTests)
import Test.Revoked.Levels (levelTests)

revokedTests :: TestSuite
revokedTests = do
    dataTests
    collisionTests
    stateTests
    levelTests