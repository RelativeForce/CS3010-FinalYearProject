module Test.Revoked.Data.Enemy ( 
    enemyTests 
) where

import Prelude

import Effect (Effect)
import Test.Revoked.Data.Enemy.Marine (marineTests)
import Test.Revoked.Data.Enemy.BigBertha (bigBerthaTests)

enemyTests :: Effect Unit
enemyTests = do
    -- Tests

    -- Sub Modules
    marineTests
    bigBerthaTests