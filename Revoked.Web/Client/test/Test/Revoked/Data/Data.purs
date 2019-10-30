module Test.Revoked.Data ( 
    dataTests 
) where

import Prelude

import Effect (Effect)
import Test.Revoked.Data.Player (playerTests)
import Test.Revoked.Data.HighScores (highScoresTests)

dataTests :: Effect Unit
dataTests = do
    -- Tests

    -- Sub Modules
    playerTests
    highScoresTests