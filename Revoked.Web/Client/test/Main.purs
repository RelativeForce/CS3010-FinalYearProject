module Test.Main where

import Prelude

import Effect (Effect)
import Test.Unit.Main (runTest)

import Test.Engine (engineTests)
import Test.Revoked (revokedTests)

main :: Effect Unit
main = do
  runTest do
    engineTests
    revokedTests

