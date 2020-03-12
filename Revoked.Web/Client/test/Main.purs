module Test.Main where

import Prelude

import Effect (Effect)
import Test.Unit.Main (runTest)

import Test.Emo8 (emo8Tests)
import Test.Revoked (revokedTests)

main :: Effect Unit
main = do
  runTest do
    emo8Tests
    revokedTests

