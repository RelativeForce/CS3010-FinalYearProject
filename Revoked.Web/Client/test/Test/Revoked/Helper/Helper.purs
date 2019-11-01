module Test.Revoked.Helper ( 
    helperTests 
) where

import Prelude

import Effect (Effect)
import Test.Revoked.Helper.AdjustPlayerPos (adjustPlayerPosTests)
import Test.Unit.Main (runTest)

helperTests :: Effect Unit
helperTests = do
    -- Tests
    runTest do
        adjustPlayerPosTests
    -- Sub Modules
    