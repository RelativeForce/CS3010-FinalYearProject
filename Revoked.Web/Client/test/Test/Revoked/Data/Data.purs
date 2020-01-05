module Test.Revoked.Data ( 
    dataTests 
) where

import Prelude

import Effect (Effect)
import Test.Revoked.Data.Player (playerTests)
import Test.Revoked.Data.Enemy (enemyTests)
import Test.Revoked.Data.Gun (gunTests)

dataTests :: Effect Unit
dataTests = do
    -- Tests

    -- Sub Modules
    playerTests
    enemyTests
    gunTests