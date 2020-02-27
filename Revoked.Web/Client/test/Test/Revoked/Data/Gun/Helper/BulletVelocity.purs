module Test.Revoked.Data.Gun.Helper.BulletVelocity ( 
    bulletVelocityTests 
) where

import Prelude

import Constants (bulletSpeed)
import Data.Gun.Helper (bulletVelocity)
import Test.Unit (TestSuite, suite, test)
import Test.Helper (equalTolerance)

bulletVelocityTests :: TestSuite
bulletVelocityTests =
    suite "Revoked.Data.Gun.Pistol - bulletVelocity" do
        test "shouldFullSpeedInXWhenAimedRight" do
            let 
                angle = 0

                expected = {
                    xSpeed: bulletSpeed,
                    ySpeed: 0.0
                }  

                result = bulletVelocity angle
            equalTolerance expected.xSpeed result.xSpeed
            equalTolerance expected.ySpeed result.ySpeed    
        test "shouldFullSpeedInYWhenAimedUp" do
            let 
                angle = 90

                expected = {
                    xSpeed: 0.0,
                    ySpeed: bulletSpeed
                }  

                result = bulletVelocity angle
            equalTolerance expected.xSpeed result.xSpeed
            equalTolerance expected.ySpeed result.ySpeed    
        test "shouldHalfSpeedInXandYWhenAimedDiagonallyRightAndUp" do
            let 
                angle = 45

                expected = {
                    xSpeed: 5.6568,
                    ySpeed: 5.6568
                }  

                result = bulletVelocity angle

            equalTolerance expected.xSpeed result.xSpeed
            equalTolerance expected.ySpeed result.ySpeed 
