module Test.Main where

import Prelude

import Effect (Effect)
import Test.Engine (engineTests)
import Test.Revoked (revokedTests)
import Test.Unit.Main (runTest)

main :: Effect Unit
main = do
  runTest do
    engineTests
    revokedTests

