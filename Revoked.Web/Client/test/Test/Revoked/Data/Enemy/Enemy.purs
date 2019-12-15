module Test.Revoked.Data.Enemy ( 
    enemyTests 
) where

import Prelude

import Effect (Effect)
import Test.Revoked.Data.Enemy.Marine (marineTests)

enemyTests :: Effect Unit
enemyTests = do
    -- Tests

    -- Sub Modules
    marineTests