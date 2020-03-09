module Test.Revoked.State ( 
    stateTests 
) where

import Prelude

import Test.Unit (TestSuite)

import Test.Revoked.State.Leaderboard (leaderboardTests)
import Test.Revoked.State.Victory (victoryTests)

stateTests :: TestSuite
stateTests = do
    leaderboardTests
    victoryTests