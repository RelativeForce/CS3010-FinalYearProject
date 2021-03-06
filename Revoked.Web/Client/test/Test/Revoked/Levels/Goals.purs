module Test.Revoked.Levels.Goals ( 
    goalsTests 
) where

import Prelude

import Test.Unit (TestSuite, suite, test)

import Revoked.Levels (goals, levelCount)

import Test.Helper (equalLength)

goalsTests :: TestSuite
goalsTests =
    suite "Revoked.Levels - goals" do
        test "SHOULD be empty WHEN mapId does not map to level" do
            let 
                mapId = levelCount

                expectedLength = 0 

                result = goals mapId
            equalLength expectedLength result
        test "SHOULD be empty WHEN mapId is 0" do
            let 
                mapId = -1

                expectedLength = 0 

                result = goals mapId
            equalLength expectedLength result

