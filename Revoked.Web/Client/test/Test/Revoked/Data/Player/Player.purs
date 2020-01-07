module Test.Revoked.Data.Player ( 
    playerTests 
) where

import Prelude

import Effect (Effect)
import Test.Revoked.Data.Player.UpdateVelocity (updateVelocityTests)
import Test.Revoked.Data.Player.Srcoll (scrollTests)
import Test.Revoked.Data.Player.BeInMonitor (beInMonitorTests)
import Test.Revoked.Data.Player.AdjustVelocity (adjustVelocityTests)
import Test.Revoked.Data.Player.NewPlayerSprite (newPlayerSpriteTests)
import Test.Revoked.Data.Player.UpdateAppear (updateAppearTests)
import Test.Revoked.Data.Player.Collide (collideTests)
import Test.Unit.Main (runTest)

playerTests :: Effect Unit
playerTests = do
    -- Tests
    runTest do
        updateVelocityTests
        scrollTests
        beInMonitorTests
        adjustVelocityTests
        newPlayerSpriteTests
        updateAppearTests
        collideTests
    -- Sub Modules