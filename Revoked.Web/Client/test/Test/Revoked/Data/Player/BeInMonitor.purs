module Test.Revoked.Data.Player.BeInMonitor ( 
    beInMonitorTests 
) where

import Prelude
import Data.Player (beInMonitor, initialPlayer, Player(..))
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)
import Emo8.Types (Y, X, Size)
import Emo8.Constants (defaultMonitorSize)

beInMonitorTests :: TestSuite
beInMonitorTests =
    suite "Revoked.Data.Player - beInMonitor" do
        test "positionShouldNotChangeWhenPlayerHasNotMovedWithInMonitorBounds" do
            let 
                x = 50
                y = 50
                oldPos = {
                    x: x,
                    y: y
                }
                newPlayer = player x y
                expectedPos = {
                    x: x,
                    y: y
                }

                (Player result) = beInMonitor oldPos newPlayer

            equal expectedPos result.pos
        
        test "positionShouldNotChangeWhenPlayerHasOutsideMonitorBoundsLeft" do
            let 
                y = 50
                oldPos = {
                    x: 0,
                    y: y
                }
                newPlayer = player (-5) y
                expectedPos = {
                    x: 0,
                    y: y
                }

                (Player result) = beInMonitor oldPos newPlayer

            equal expectedPos result.pos

        test "positionShouldNotChangeWhenPlayerHasOutsideMonitorBoundsDown" do
            let 
                x = 50
                oldPos = {
                    x: x,
                    y: 0
                }
                newPlayer = player x (-5)
                expectedPos = {
                    x: x,
                    y: 0
                }

                (Player result) = beInMonitor oldPos newPlayer

            equal expectedPos result.pos

        test "positionShouldNotChangeWhenPlayerHasOutsideMonitorBoundsUp" do
            let 
                x = 50
                yBoundry = defaultMonitorSize.height - spriteSize.height
                oldPos = {
                    x: x,
                    y: 0
                }
                newPlayer = player x (yBoundry + 5)
                expectedPos = {
                    x: x,
                    y: yBoundry
                }

                (Player result) = beInMonitor oldPos newPlayer

            equal expectedPos result.pos

        test "positionShouldNotChangeWhenPlayerHasOutsideMonitorBoundsRight" do
            let 
                y = 50
                xBoundry = defaultMonitorSize.width - spriteSize.width
                oldPos = {
                    x: 0,
                    y: y
                }
                newPlayer = player (xBoundry + 5) y
                expectedPos = {
                    x: xBoundry,
                    y: y
                }

                (Player result) = beInMonitor oldPos newPlayer

            equal expectedPos result.pos
        test "positionShouldNotChangeWhenPlayerHasOutsideMonitorBoundsRightAndUp" do
            let 
                xBoundry = defaultMonitorSize.width - spriteSize.width
                yBoundry = defaultMonitorSize.height - spriteSize.height
                oldPos = {
                    x: 0,
                    y: 0
                }
                newPlayer = player (xBoundry + 5) (yBoundry + 5)
                expectedPos = {
                    x: xBoundry,
                    y: yBoundry
                }

                (Player result) = beInMonitor oldPos newPlayer

            equal expectedPos result.pos


player :: X -> Y -> Player
player x y = initialPlayer { x: x, y: y } 

spriteSize :: Size
spriteSize = p.sprite.size
    where 
        (Player p) = initialPlayer { x: 0, y: 0 }
