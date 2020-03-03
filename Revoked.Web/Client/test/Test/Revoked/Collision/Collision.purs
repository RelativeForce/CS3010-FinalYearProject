module Test.Revoked.Collision ( 
    collisionTests 
) where

import Prelude

import Test.Revoked.Collision.AdjustY (adjustYTests)
import Test.Revoked.Collision.AdjustX (adjustXTests)
import Test.Unit (TestSuite)

collisionTests :: TestSuite
collisionTests = do
    adjustXTests
    adjustYTests