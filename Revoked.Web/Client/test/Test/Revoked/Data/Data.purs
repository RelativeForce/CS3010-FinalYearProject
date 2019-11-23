module Test.Revoked.Data ( 
    dataTests 
) where

import Prelude

import Effect (Effect)
import Test.Revoked.Data.Player (playerTests)

dataTests :: Effect Unit
dataTests = do
    -- Tests

    -- Sub Modules
    playerTests