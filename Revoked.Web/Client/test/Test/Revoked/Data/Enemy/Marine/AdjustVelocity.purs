module Test.Revoked.Data.Enemy.Marine.AdjustVelocity ( 
    adjustVelocityTests 
) where

import Prelude

import Revoked.Constants (marineWalkSpeed)
import Data.Enemy.Marine (adjustVelocity, defaultMarine)
import Revoked.Data.Player (Player, initialPlayer)
import Emo8.Types (Position)
import Test.Helper (equalTolerance)
import Test.Unit (TestSuite, suite, test)

adjustVelocityTests :: TestSuite
adjustVelocityTests =
    suite "Revoked.Data.Enemy.Marine - adjustVelocity" do
        test "SHOULD maintain speed in x WHEN x position has changed AND moving only in y" do
            let 
                oldPos = {
                    x: 0,
                    y: 0
                }
                newPos = {
                    x: 5,
                    y: 0
                } 
                currentVelocity = {
                    xSpeed: marineWalkSpeed,
                    ySpeed: 0.0
                }
                marine = (defaultMarine 1 newPos) {
                    velocity = currentVelocity
                }
                
                expectedXSpeed = currentVelocity.xSpeed  
                expectedYSpeed = currentVelocity.ySpeed  

                result = adjustVelocity oldPos marine

            equalTolerance expectedXSpeed result.velocity.xSpeed    
            equalTolerance expectedYSpeed result.velocity.ySpeed  
        test "SHOULD maintain speed in y WHEN y position has changed AND moving only in y" do
            let 
                oldPos = {
                    x: 0,
                    y: 0
                }
                newPos = {
                    x: 0,
                    y: 5
                } 
                currentVelocity = {
                    xSpeed: 0.0,
                    ySpeed: 1.0
                }
                marine = (defaultMarine 1 newPos) {
                    velocity = currentVelocity
                }
                
                expectedXSpeed = currentVelocity.xSpeed  
                expectedYSpeed = currentVelocity.ySpeed  

                result = adjustVelocity oldPos marine

            equalTolerance expectedXSpeed result.velocity.xSpeed    
            equalTolerance expectedYSpeed result.velocity.ySpeed  
        test "SHOULD maintain speed in y and x WHEN x and y position has changed AND moving in x and y" do
            let 
                oldPos = {
                    x: 0,
                    y: 0
                }
                newPos = {
                    x: 5,
                    y: 5
                } 
                currentVelocity = {
                    xSpeed: marineWalkSpeed,
                    ySpeed: 1.0
                }
                marine = (defaultMarine 1 newPos) {
                    velocity = currentVelocity
                }
                
                expectedXSpeed = currentVelocity.xSpeed  
                expectedYSpeed = currentVelocity.ySpeed  

                result = adjustVelocity oldPos marine

            equalTolerance expectedXSpeed result.velocity.xSpeed    
            equalTolerance expectedYSpeed result.velocity.ySpeed 
        test "SHOULD stop in x WHEN x position has not changed AND moving only in x" do
            let 
                oldPos = {
                    x: 0,
                    y: 0
                }
                newPos = {
                    x: 0,
                    y: 0
                } 
                currentVelocity = {
                    xSpeed: marineWalkSpeed,
                    ySpeed: 0.0
                }
                marine = (defaultMarine 1 newPos) {
                    velocity = currentVelocity
                }
                
                expectedXSpeed = 0.0  
                expectedYSpeed = currentVelocity.ySpeed  

                result = adjustVelocity oldPos marine

            equalTolerance expectedXSpeed result.velocity.xSpeed    
            equalTolerance expectedYSpeed result.velocity.ySpeed 
        test "SHOULD stop in y WHEN y position has not changed AND moving only in y" do
            let 
                oldPos = {
                    x: 0,
                    y: 0
                }
                newPos = {
                    x: 0,
                    y: 0
                } 
                currentVelocity = {
                    xSpeed: marineWalkSpeed,
                    ySpeed: 1.0
                }
                marine = (defaultMarine 1 newPos) {
                    velocity = currentVelocity
                }
                
                expectedXSpeed = 0.0  
                expectedYSpeed = 0.0  

                result = adjustVelocity oldPos marine

            equalTolerance expectedXSpeed result.velocity.xSpeed    
            equalTolerance expectedYSpeed result.velocity.ySpeed
        test "SHOULD stop in x and y WHEN x and y position has not changed AND moving in x and y" do
            let 
                pos = {
                    x: 0,
                    y: 0
                }
                currentVelocity = {
                    xSpeed: 0.0,
                    ySpeed: 1.0
                }
                marine = (defaultMarine 1 pos) {
                    velocity = currentVelocity
                }
                
                expectedXSpeed = 0.0  
                expectedYSpeed = 0.0  

                result = adjustVelocity pos marine

            equalTolerance expectedXSpeed result.velocity.xSpeed    
            equalTolerance expectedYSpeed result.velocity.ySpeed

player :: Position -> Player
player pos = initialPlayer pos