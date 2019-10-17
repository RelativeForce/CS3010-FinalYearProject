module Test.Revoked.Data.Player ( 
    playerTests 
) where

import Prelude

import Effect (Effect)
import Test.Revoked.Data.Player.UpdateVelocity (updateVelocityTests)
import Test.Unit.Main (runTest)

playerTests :: Effect Unit
playerTests = do
    -- Tests
    runTest do
        updateVelocityTests
    -- Sub Modules