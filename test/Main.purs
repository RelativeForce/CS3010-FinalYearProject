module Test.Main where

import Prelude

import Effect (Effect)
import Test.ParseSound (parseSoundTests)
import Test.RawSemigroup (rawSemigroupTests)
import Test.Sprite (frameFileNameTests)
import Test.Unit.Main (runTest)

main :: Effect Unit
main =
  runTest do
    parseSoundTests
    rawSemigroupTests
    frameFileNameTests
