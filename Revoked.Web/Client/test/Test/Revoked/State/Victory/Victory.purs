module Test.Revoked.State.Victory ( 
    victoryTests 
) where

import Test.Unit (TestSuite)

import Test.Revoked.State.Victory.UpdateVictory (updateVictoryTests)

victoryTests :: TestSuite
victoryTests = do
    updateVictoryTests