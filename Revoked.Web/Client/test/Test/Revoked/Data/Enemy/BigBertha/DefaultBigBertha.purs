module Test.Revoked.Data.Enemy.BigBertha.DefaultBigBertha ( 
    defaultBigBerthaTests 
) where

import Data.Enemy.BigBertha (defaultBigBertha)
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)

defaultBigBerthaTests :: TestSuite
defaultBigBerthaTests =
    suite "Revoked.Data.Enemy.BigBertha - defaultBigBertha" do
        test "shouldHave15AsInitialHealth" do
            let 
                leftLimit = {  x: 0, y: 5 }
                rightLimit = { x: 15, y: 5 } 
                expected = 15  

                result = defaultBigBertha leftLimit rightLimit
            equal expected result.health    
