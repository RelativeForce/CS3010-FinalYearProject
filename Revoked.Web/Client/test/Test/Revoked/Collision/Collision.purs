module Test.Revoked.Collision ( 
    collisionTests 
) where

import Prelude

import Test.Unit (TestSuite)

import Test.Revoked.Collision.AdjustY (adjustYTests)
import Test.Revoked.Collision.AdjustX (adjustXTests)
collisionTests :: TestSuite
collisionTests = do
    adjustXTests
    adjustYTests