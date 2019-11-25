module Test.Revoked ( 
    revokedTests 
) where

import Prelude

import Effect (Effect)
import Test.Revoked.Collision (collisionTests)
import Test.Revoked.Data (dataTests)

revokedTests :: Effect Unit
revokedTests = do
    -- Tests

    -- Sub Modules
    dataTests
    collisionTests