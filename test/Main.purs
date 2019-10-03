module Test.Main where

import Prelude

import Effect (Effect)
import Test.Unit.Main (runTest)
import Test.Parse (parseTests)
import Test.Sprite (spriteTests)

main :: Effect Unit
main =
  do
    -- Tests
          
    -- Sub Modules
    parseTests
    spriteTests

