module Test.Revoked.Data.Enemy.BigBertha.Helper.EnsureRightLimit ( 
    ensureRightLimitTests 
) where

import Prelude

import Revoked.Data.Enemy.BigBertha.Helper (ensureRightLimit)
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)

ensureRightLimitTests :: TestSuite
ensureRightLimitTests =
    suite "Revoked.Data.Enemy.BigBertha.Helper - ensureRightLimit" do
        test "SHOULD be right limit WHEN left limit x < right limit x" do
            let 
                leftLimit = {  x: 0, y: 5 }
                rightLimit = { x: 15, y: 5 } 

                expectedPos = rightLimit

                result = ensureRightLimit leftLimit rightLimit
            equal expectedPos result

        test "SHOULD be left limit WHEN left limit x > right limit x" do
            let 
                leftLimit = {  x: 15, y: 5 }
                rightLimit = { x: 0, y: 5 } 

                expectedPos = leftLimit

                result = ensureRightLimit leftLimit rightLimit
            equal expectedPos result      
