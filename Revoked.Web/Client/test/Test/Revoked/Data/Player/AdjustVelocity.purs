module Test.Revoked.Data.Player.AdjustVelocity ( 
    adjustVelocityTests 
) where

import Prelude
import Data.Player (adjustVelocity, Player(..), initialPlayer)
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)
import Emo8.Types (Y, X, Velocity)

adjustVelocityTests :: TestSuite
adjustVelocityTests =
    suite "Revoked.Data.Player - adjustVelocity" do
        test "ShouldAdjustVelocityToZeroInXandYWhenPositionHasNotChangedInXandY" do
            let 
                x = 50
                y = 50
                oldPos = {
                    x: x,
                    y: y
                }
                velocity = {
                    xSpeed: 5.0,
                    ySpeed: 7.0
                }   
                newPlayer = player x y velocity
                expectedVelocity = {
                    xSpeed: 0.0,
                    ySpeed: 0.0
                }   

                (Player result) = adjustVelocity oldPos newPlayer

            equal expectedVelocity result.velocity
        test "ShouldAdjustVelocityToZeroInXWhenPositionHasNotChangedInX" do
            let 
                x = 50
                ySpeed = 6.7
                oldPos = {
                    x: x,
                    y: 57
                }
                velocity = {
                    xSpeed: 5.0,
                    ySpeed: ySpeed
                }   
                newPlayer = player x 46 velocity
                expectedVelocity = {
                    xSpeed: 0.0,
                    ySpeed: ySpeed
                }   

                (Player result) = adjustVelocity oldPos newPlayer

            equal expectedVelocity result.velocity
        test "ShouldAdjustVelocityToZeroInYWhenPositionHasNotChangedInY" do
            let 
                xSpeed = 57.6
                y = 50
                oldPos = {
                    x: 34,
                    y: y
                }
                velocity = {
                    xSpeed: xSpeed,
                    ySpeed: 7.0
                }   
                newPlayer = player 45 y velocity
                expectedVelocity = {
                    xSpeed: xSpeed,
                    ySpeed: 0.0
                }   

                (Player result) = adjustVelocity oldPos newPlayer

            equal expectedVelocity result.velocity
        test "ShouldNotAdjustVelocityInXorYWhenPositionHasChangedInBothXandY" do
            let 
                xSpeed = 34.6
                ySpeed = 2.4
                oldPos = {
                    x: 45,
                    y: 76
                }
                velocity = {
                    xSpeed: xSpeed,
                    ySpeed: ySpeed
                }   
                newPlayer = player 34 13 velocity
                expectedVelocity = {
                    xSpeed: xSpeed,
                    ySpeed: ySpeed
                }   

                (Player result) = adjustVelocity oldPos newPlayer

            equal expectedVelocity result.velocity

player :: X -> Y -> Velocity -> Player
player x y v = Player $ p { velocity = v, pos = { x: x, y: y } }
    where 
        (Player p) = initialPlayer
