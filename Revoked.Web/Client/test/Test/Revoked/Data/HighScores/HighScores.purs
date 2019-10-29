module Test.Revoked.Data.HighScores ( 
    highScoresTests 
) where

import Prelude

import Effect (Effect)
import Test.Revoked.Data.HighScores.EncodePlayerScore (encodePlayerScoreTests)
import Test.Unit.Main (runTest)

highScoresTests :: Effect Unit
highScoresTests = do
    -- Tests
    runTest do
        encodePlayerScoreTests
    -- Sub Modules