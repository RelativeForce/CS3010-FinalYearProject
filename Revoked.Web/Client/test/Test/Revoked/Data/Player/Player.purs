module Test.Revoked.Data.Player ( 
    playerTests 
) where

import Prelude

import Effect (Effect)
import Test.Revoked.Data.Player.UpdateVelocity (updateVelocityTests)
import Test.Revoked.Data.Player.UpdatePosition (updatePositionTests)
import Test.Revoked.Data.Player.AdjustY (adjustYTests)
import Test.Revoked.Data.Player.AdjustX (adjustXTests)
import Test.Unit.Main (runTest)

playerTests :: Effect Unit
playerTests = do
    -- Tests
    runTest do
        updateVelocityTests
        updatePositionTests
        adjustXTests
        adjustYTests
    -- Sub Modules