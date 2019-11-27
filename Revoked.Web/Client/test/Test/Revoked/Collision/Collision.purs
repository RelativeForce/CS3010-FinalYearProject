module Test.Revoked.Collision ( 
    collisionTests 
) where

import Prelude

import Effect (Effect)
import Test.Revoked.Collision.AdjustY (adjustYTests)
import Test.Revoked.Collision.AdjustX (adjustXTests)
import Test.Unit.Main (runTest)

collisionTests :: Effect Unit
collisionTests = do
    -- Tests
    runTest do
        adjustXTests
        adjustYTests
    -- Sub Modules