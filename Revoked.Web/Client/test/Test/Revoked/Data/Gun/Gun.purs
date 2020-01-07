module Test.Revoked.Data.Gun ( 
    gunTests 
) where

import Prelude

import Effect (Effect)
import Test.Revoked.Data.Gun.Pistol (pistolTests)

gunTests :: Effect Unit
gunTests = do
    -- Tests

    -- Sub Modules
    pistolTests