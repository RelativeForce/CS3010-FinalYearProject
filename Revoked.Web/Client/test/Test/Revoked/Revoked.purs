module Test.Revoked ( 
    revokedTests 
) where

import Prelude

import Effect (Effect)
import Test.Revoked.Data (dataTests)
import Test.Revoked.Helper (helperTests)

revokedTests :: Effect Unit
revokedTests = do
    -- Tests

    -- Sub Modules
    dataTests
    helperTests