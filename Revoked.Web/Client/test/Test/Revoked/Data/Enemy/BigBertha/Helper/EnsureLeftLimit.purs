module Test.Revoked.Data.Enemy.BigBertha.Helper.EnsureLeftLimit ( 
    ensureLeftLimitTests 
) where

import Prelude

import Revoked.Data.Enemy.BigBertha.Helper (ensureLeftLimit)
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)

ensureLeftLimitTests :: TestSuite
ensureLeftLimitTests =
    suite "Revoked.Data.Enemy.BigBertha.Helper - ensureLeftLimit" do
        test "SHOULD be left limit WHEN left limit x < right limit x" do
            let 
                leftLimit = {  x: 0, y: 5 }
                rightLimit = { x: 15, y: 5 } 

                expectedPos = leftLimit

                result = ensureLeftLimit leftLimit rightLimit
            equal expectedPos result

        test "SHOULD be right limit WHEN left limit x > right limit x" do
            let 
                leftLimit = {  x: 15, y: 5 }
                rightLimit = { x: 0, y: 5 } 

                expectedPos = rightLimit

                result = ensureLeftLimit leftLimit rightLimit
            equal expectedPos result      
