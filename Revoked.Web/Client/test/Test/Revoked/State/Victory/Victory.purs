module Test.Revoked.State.Victory ( 
    victoryTests 
) where

import Test.Revoked.State.Victory.UpdateVictory (updateVictoryTests)
import Test.Unit (TestSuite)

victoryTests :: TestSuite
victoryTests = do
    updateVictoryTests