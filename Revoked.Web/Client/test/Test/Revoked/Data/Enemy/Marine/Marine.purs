module Test.Revoked.Data.Enemy.Marine ( 
    marineTests 
) where

import Prelude

import Effect (Effect)
import Test.Revoked.Data.Enemy.Marine.PlayerInRange (playerInRangeTests)
import Test.Unit.Main (runTest)

marineTests :: Effect Unit
marineTests = do
    -- Tests
    runTest do
        playerInRangeTests
    -- Sub Modules