module Test.Revoked.Levels ( 
    levelTests 
) where

import Prelude

import Test.Unit (TestSuite)

import Test.Revoked.Levels.Enemies (enemiesTests)
import Test.Revoked.Levels.Goals (goalsTests)

levelTests :: TestSuite
levelTests = do
    enemiesTests
    goalsTests