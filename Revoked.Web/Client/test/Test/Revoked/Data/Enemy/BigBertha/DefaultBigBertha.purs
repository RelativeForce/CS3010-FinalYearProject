module Test.Revoked.Data.Enemy.BigBertha.DefaultBigBertha ( 
    defaultBigBerthaTests 
) where

import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)

import Revoked.Data.Enemy.BigBertha (defaultBigBertha)

defaultBigBerthaTests :: TestSuite
defaultBigBerthaTests =
    suite "Revoked.Data.Enemy.BigBertha - defaultBigBertha" do
        test "SHOULD have 15 as initial health" do
            let 
                leftLimit = {  x: 0, y: 5 }
                rightLimit = { x: 15, y: 5 } 
                expected = 15  

                result = defaultBigBertha leftLimit rightLimit
            equal expected result.health    
