module Test.Revoked.Data.Gun.Helper ( 
    helperTests 
) where

import Prelude

import Effect (Effect)
import Test.Revoked.Data.Gun.Helper.BulletVelocity (bulletVelocityTests)
import Test.Unit.Main (runTest)

helperTests :: Effect Unit
helperTests = do
    -- Tests
    runTest do
        bulletVelocityTests
    -- Sub Modules