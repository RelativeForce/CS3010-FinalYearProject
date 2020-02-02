module Test.Revoked.Data.Gun.Pistol ( 
    pistolTests 
) where

import Prelude

import Effect (Effect)
import Test.Revoked.Data.Gun.Pistol.CanFire (canFireTests)
import Test.Unit.Main (runTest)

pistolTests :: Effect Unit
pistolTests = do
    -- Tests
    runTest do
        canFireTests
    -- Sub Modules