module Test.Revoked.Data.Enemy.Marine.VelocityOfMarineBullet ( 
    velocityOfMarineBulletTests 
) where

import Prelude

import Constants (marineAgroRange, marineBulletSpeed)
import Data.Enemy.Marine (velocityOfMarineBullet)
import Data.Int (floor)
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)

velocityOfMarineBulletTests :: TestSuite
velocityOfMarineBulletTests =
    suite "Revoked.Data.Enemy.Marine - velocityOfMarineBullet" do
        test "shouldFullSpeedInXWhenPlayerAndMarineHaveSameXPosition" do
            let 
                playerPos = {
                    x: (floor marineAgroRange) - 1,
                    y: 0
                }
                marinePos = {
                    x: 0,
                    y: 0
                } 
                expected = {
                    xSpeed: marineBulletSpeed,
                    ySpeed: 0.0
                }  

                result = velocityOfMarineBullet marinePos playerPos
            equal expected result    
        test "shouldFullSpeedInYWhenPlayerAndMarineHaveSameYPosition" do
            let 
                playerPos = {
                    x: 0,
                    y: (floor marineAgroRange) - 1
                }
                marinePos = {
                    x: 0,
                    y: 0
                } 
                expected = {
                    xSpeed: 0.0,
                    ySpeed: marineBulletSpeed
                }  

                result = velocityOfMarineBullet marinePos playerPos
            equal expected result    
        test "shouldHalfSpeedInXandYWhenXandYPositionDifferenceAreSame" do
            let 
                playerPos = {
                    x: 50,
                    y: 50
                }
                marinePos = {
                    x: 0,
                    y: 0
                } 
                expected = {
                    xSpeed: marineBulletSpeed / 2.0,
                    ySpeed: marineBulletSpeed / 2.0
                }  

                result = velocityOfMarineBullet marinePos playerPos
            equal expected result   
