module Test.Revoked.Data.Player.BeInMonitor ( 
    beInMonitorTests 
) where

import Prelude

import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)

import Emo8.Types (Y, X, Size)
import Emo8.Constants (defaultMonitorSize)

import Revoked.Data.Player (beInMonitor, initialPlayer, Player(..), PlayerState)

beInMonitorTests :: TestSuite
beInMonitorTests =
    suite "Revoked.Data.Player - beInMonitor" do
        test "SHOULD not change position WHEN player has not moved within MonitorBounds" do
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

                result = beInMonitor oldPos newPlayer

            equal expectedPos result.pos
        
        test "SHOULD not change position WHEN player is outside MonitorBounds on left edge" do
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

                result = beInMonitor oldPos newPlayer

            equal expectedPos result.pos

        test "SHOULD not change position WHEN player is outside MonitorBounds on bottom edge" do
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

                result = beInMonitor oldPos newPlayer

            equal expectedPos result.pos

        test "SHOULD not change position WHEN player is outside MonitorBounds on top edge" do
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

                result = beInMonitor oldPos newPlayer

            equal expectedPos result.pos

        test "SHOULD not change position WHEN player is outside MonitorBounds on right edge" do
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

                result = beInMonitor oldPos newPlayer

            equal expectedPos result.pos
        test "SHOULD not change position WHEN player is outside MonitorBounds on both top and right" do
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

                result = beInMonitor oldPos newPlayer

            equal expectedPos result.pos


player :: X -> Y -> PlayerState
player x y = p
    where
        (Player p) = initialPlayer { x: x, y: y } 

spriteSize :: Size
spriteSize = p.sprite.size
    where 
        (Player p) = initialPlayer { x: 0, y: 0 }
