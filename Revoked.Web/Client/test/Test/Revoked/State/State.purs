module Test.Revoked.State ( 
    stateTests 
) where

import Prelude

import Effect (Effect)
import Test.Revoked.State.Leaderboard (leaderboardTests)
import Test.Revoked.State.Victory (victoryTests)

stateTests :: Effect Unit
stateTests = do
    -- Tests

    -- Sub Modules
    leaderboardTests
    victoryTests