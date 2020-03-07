module Test.Revoked.State ( 
    stateTests 
) where

import Prelude

import Test.Revoked.State.Leaderboard (leaderboardTests)
import Test.Revoked.State.Victory (victoryTests)
import Test.Unit (TestSuite)

stateTests :: TestSuite
stateTests = do
    leaderboardTests
    victoryTests