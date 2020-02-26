module Test.Revoked.State.Leaderboard ( 
    leaderboardTests 
) where

import Prelude

import Effect (Effect)
import Test.Revoked.State.Leaderboard.UpdateLeaderboard (updateLeaderboardTests)
import Test.Unit.Main (runTest)

leaderboardTests :: Effect Unit
leaderboardTests = do
    -- Tests
    runTest do
        updateLeaderboardTests