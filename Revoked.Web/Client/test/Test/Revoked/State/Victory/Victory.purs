module Test.Revoked.State.Victory ( 
    victoryTests 
) where

import Prelude

import Effect (Effect)
import Test.Revoked.State.Victory.UpdateVictory (updateVictoryTests)
import Test.Unit.Main (runTest)

victoryTests :: Effect Unit
victoryTests = do
    -- Tests
    runTest do
        updateVictoryTests