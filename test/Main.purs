module Test.Main where

import Prelude

import Effect (Effect)
import Test.Unit.Main (runTest)
import Test.Parse (parseTests)
import Test.Sprite (frameFileNameTests)

main :: Effect Unit
main =
  do
    -- Tests
    runTest do
      frameFileNameTests
    -- Sub Modules
    parseTests

