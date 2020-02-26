module Test.Revoked.Data.Enemy.BigBertha.IsImmune ( 
    isImmuneTests 
) where

import Prelude
import Data.Enemy.BigBertha (defaultBigBertha, isImmune)
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)

isImmuneTests :: TestSuite
isImmuneTests =
    suite "Revoked.Data.Enemy.BigBertha - isImmune" do
        test "shouldBeImmuneWhenCooldownIsGreaterThanZero" do
            let 
                leftLimit = {  x: 0, y: 5 }
                rightLimit = { x: 15, y: 5 } 
                bigBertha = (defaultBigBertha leftLimit rightLimit) {
                    immuneCooldown = 1
                }

                expected = true  

                result = isImmune bigBertha
            equal expected result  
        test "shouldNOTBeImmuneWhenCooldownIsZero" do
            let 
                leftLimit = {  x: 0, y: 5 }
                rightLimit = { x: 15, y: 5 } 
                bigBertha = (defaultBigBertha leftLimit rightLimit) {
                    immuneCooldown = 0
                }

                expected = false  

                result = isImmune bigBertha
            equal expected result  
