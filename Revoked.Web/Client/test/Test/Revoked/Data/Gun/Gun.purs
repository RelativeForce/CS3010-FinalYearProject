module Test.Revoked.Data.Gun ( 
    gunTests 
) where

import Prelude

import Effect (Effect)
import Test.Revoked.Data.Gun.Pistol (pistolTests)
import Test.Revoked.Data.Gun.Helper (helperTests)

gunTests :: Effect Unit
gunTests = do
    -- Tests

    -- Sub Modules
    pistolTests
    helperTests