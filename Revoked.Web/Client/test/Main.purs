module Test.Main where

import Prelude

import Effect (Effect)
import Test.Engine (engineTests)
import Test.Revoked (revokedTests)

main :: Effect Unit
main =
  do
    -- Tests
    
    -- Sub Modules
    engineTests
    revokedTests

