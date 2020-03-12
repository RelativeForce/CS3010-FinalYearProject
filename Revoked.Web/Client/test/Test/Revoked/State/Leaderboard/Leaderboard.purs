module Test.Revoked.State.Leaderboard ( 
    leaderboardTests 
) where

import Test.Unit (TestSuite)

import Test.Revoked.State.Leaderboard.UpdateLeaderboard (updateLeaderboardTests)

leaderboardTests :: TestSuite
leaderboardTests = do
    updateLeaderboardTests