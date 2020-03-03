module Test.Revoked.Data.Enemy.BigBertha.Helper ( 
    helperTests 
) where

import Prelude

import Effect (Effect)
import Test.Revoked.Data.Enemy.BigBertha.Helper.EnsureLeftLimit (ensureLeftLimitTests)
import Test.Revoked.Data.Enemy.BigBertha.Helper.PlayerInRange (playerInRangeTests)
import Test.Revoked.Data.Enemy.BigBertha.Helper.CoolDownShot (coolDownShotTests)
import Test.Revoked.Data.Enemy.BigBertha.Helper.EnsureRightLimit (ensureRightLimitTests)
import Test.Unit.Main (runTest)

helperTests :: Effect Unit
helperTests = do
    -- Sub Modules

    -- Tests
    runTest do
        ensureLeftLimitTests
        playerInRangeTests
        coolDownShotTests
        ensureRightLimitTests
    