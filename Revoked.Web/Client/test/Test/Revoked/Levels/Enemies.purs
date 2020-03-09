module Test.Revoked.Levels.Enemies ( 
    enemiesTests 
) where

import Prelude

import Test.Unit (TestSuite, suite, test)

import Revoked.Levels (enemies, levelCount)

import Test.Helper (equalLength)

enemiesTests :: TestSuite
enemiesTests =
    suite "Revoked.Levels - enemies" do
        test "SHOULD be empty WHEN mapId does not map to level" do
            let 
                mapId = levelCount

                expectedLength = 0 

                result = enemies mapId
            equalLength expectedLength result

        test "SHOULD be empty WHEN mapId is 0" do
            let 
                mapId = -1

                expectedLength = 0 

                result = enemies mapId
            equalLength expectedLength result