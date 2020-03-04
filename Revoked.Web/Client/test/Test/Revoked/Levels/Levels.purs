module Test.Revoked.Levels ( 
    levelTests 
) where

import Prelude

import Test.Revoked.Levels.Enemies (enemiesTests)
import Test.Revoked.Levels.Goals (goalsTests)
import Test.Unit (TestSuite)

levelTests :: TestSuite
levelTests = do
    enemiesTests
    goalsTests