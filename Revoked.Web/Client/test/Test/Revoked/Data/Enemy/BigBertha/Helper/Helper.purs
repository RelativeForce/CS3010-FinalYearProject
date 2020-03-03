module Test.Revoked.Data.Enemy.BigBertha.Helper ( 
    helperTests 
) where

import Prelude

import Test.Revoked.Data.Enemy.BigBertha.Helper.EnsureLeftLimit (ensureLeftLimitTests)
import Test.Revoked.Data.Enemy.BigBertha.Helper.PlayerInRange (playerInRangeTests)
import Test.Revoked.Data.Enemy.BigBertha.Helper.CoolDownShot (coolDownShotTests)
import Test.Revoked.Data.Enemy.BigBertha.Helper.EnsureRightLimit (ensureRightLimitTests)
import Test.Revoked.Data.Enemy.BigBertha.Helper.UpdatePosition (updatePositionTests)
import Test.Unit (TestSuite)

helperTests :: TestSuite
helperTests = do
    ensureLeftLimitTests
    playerInRangeTests
    coolDownShotTests
    ensureRightLimitTests
    updatePositionTests
    