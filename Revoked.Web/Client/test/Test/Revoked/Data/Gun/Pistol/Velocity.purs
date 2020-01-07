module Test.Revoked.Data.Gun.Pistol.BulletVelocity ( 
    bulletVelocityTests 
) where

import Prelude

import Constants (bulletSpeed)
import Data.Gun.Pistol (bulletVelocity)
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)

accuracyTolerance :: Number
accuracyTolerance = 0.001

bulletVelocityTests :: TestSuite
bulletVelocityTests =
    suite "Test.Revoked.Data.Gun.Pistol - bulletVelocity" do
        test "shouldFullSpeedInXWhenAimedRight" do
            let 
                angle = 0

                expected = {
                    xSpeed: bulletSpeed,
                    ySpeed: 0.0
                }  

                result = bulletVelocity angle
            equal true $ isWithinTolerance expected.xSpeed result.xSpeed
            equal true $ isWithinTolerance expected.ySpeed result.ySpeed    
        test "shouldFullSpeedInYWhenAimedUp" do
            let 
                angle = 90

                expected = {
                    xSpeed: 0.0,
                    ySpeed: bulletSpeed
                }  

                result = bulletVelocity angle
            equal true $ isWithinTolerance expected.xSpeed result.xSpeed
            equal true $ isWithinTolerance expected.ySpeed result.ySpeed    
        test "shouldHalfSpeedInXandYWhenAimedDiagonallyRightAndUp" do
            let 
                angle = 45

                expected = {
                    xSpeed: 5.6568,
                    ySpeed: 5.6568
                }  

                result = bulletVelocity angle

            equal true $ isWithinTolerance expected.xSpeed result.xSpeed
            equal true $ isWithinTolerance expected.ySpeed result.ySpeed 

isWithinTolerance :: Number -> Number -> Boolean
isWithinTolerance a b = a <= b + accuracyTolerance && a >= b - accuracyTolerance 
