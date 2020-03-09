module Test.Revoked.Data.Bullet.ToBulletVelocity ( 
    toBulletVelocityTests 
) where

import Prelude

import Revoked.Constants (bulletSpeed)
import Data.Bullet (toBulletVelocity)
import Test.Unit (TestSuite, suite, test)
import Test.Helper (equalTolerance)

toBulletVelocityTests :: TestSuite
toBulletVelocityTests =
    suite "Revoked.Data.Bullet - toBulletVelocity" do
        test "SHOULD have full speed in X WHEN aimed right" do
            let 
                angle = 0

                expected = {
                    xSpeed: bulletSpeed,
                    ySpeed: 0.0
                }  

                result = toBulletVelocity angle
            equalTolerance expected.xSpeed result.xSpeed
            equalTolerance expected.ySpeed result.ySpeed    
        test "SHOULD have full speed in Y WHEN aimed up" do
            let 
                angle = 90

                expected = {
                    xSpeed: 0.0,
                    ySpeed: bulletSpeed
                }  

                result = toBulletVelocity angle
            equalTolerance expected.xSpeed result.xSpeed
            equalTolerance expected.ySpeed result.ySpeed    
        test "SHOULD have half speed in X AND half speed in Y WHEN aimed diagonally right and up" do
            let 
                angle = 45

                expected = {
                    xSpeed: 5.6568,
                    ySpeed: 5.6568
                }  

                result = toBulletVelocity angle

            equalTolerance expected.xSpeed result.xSpeed
            equalTolerance expected.ySpeed result.ySpeed 
