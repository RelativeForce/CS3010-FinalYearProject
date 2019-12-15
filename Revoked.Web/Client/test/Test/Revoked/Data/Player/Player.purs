module Test.Revoked.Data.Player ( 
    playerTests 
) where

import Prelude

import Effect (Effect)
import Test.Revoked.Data.Player.UpdateVelocity (updateVelocityTests)
import Test.Revoked.Data.Player.Srcoll (scrollTests)
import Test.Revoked.Data.Player.UpdateEnergy (updateEnergyTests)
import Test.Revoked.Data.Player.CanFire (canFireTests)
import Test.Unit.Main (runTest)

playerTests :: Effect Unit
playerTests = do
    -- Tests
    runTest do
        updateEnergyTests
        updateVelocityTests
        scrollTests
        canFireTests
    -- Sub Modules