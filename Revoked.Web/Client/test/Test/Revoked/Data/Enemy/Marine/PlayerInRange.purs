module Test.Revoked.Data.Enemy.Marine.PlayerInRange ( 
    playerInRangeTests 
) where

import Prelude

import Data.Int (floor)
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)

import Emo8.Types (Position)

import Revoked.Constants (marineAgroRange)
import Revoked.Data.Enemy.Marine (playerInRange, defaultMarine)
import Revoked.Data.Player (Player, initialPlayer)

playerInRangeTests :: TestSuite
playerInRangeTests =
    suite "Revoked.Data.Enemy.Marine - playerInRange" do
        test "SHOULD be in range WHEN player has same position as marine" do
            let 
                playerPos = {
                    x: 3,
                    y: 5
                }
                marinePos = {
                    x: 3,
                    y: 5
                } 
                marine = defaultMarine 1 marinePos
                newPlayer = player playerPos
                expected = true  

                result = playerInRange newPlayer marine
            equal expected result    
        test "SHOULD not be in range WHEN player and marine are at boundry in X" do
            let 
                playerPos = {
                    x: (floor marineAgroRange),
                    y: 0
                }
                marinePos = {
                    x: 0,
                    y: 0
                } 
                marine = defaultMarine 1 marinePos
                newPlayer = player playerPos
                expected = false  

                result = playerInRange newPlayer marine
            equal expected result   
        test "SHOULD be in range WHEN player and marine is within boundry in X" do
            let 
                playerPos = {
                    x: (floor marineAgroRange) - 1,
                    y: 0
                }
                marinePos = {
                    x: 0,
                    y: 0
                } 
                marine = defaultMarine 1 marinePos
                newPlayer = player playerPos
                expected = true  

                result = playerInRange newPlayer marine
            equal expected result 
        test "SHOULD not be in range WHEN player and marine are at boundry in Y" do
            let 
                playerPos = {
                    x: 0,
                    y: (floor marineAgroRange)
                }
                marinePos = {
                    x: 0,
                    y: 0
                } 
                marine = defaultMarine 1 marinePos
                newPlayer = player playerPos
                expected = false  

                result = playerInRange newPlayer marine
            equal expected result   
        test "SHOULD be in range WHEN player and marine is within boundry in Y" do
            let 
                playerPos = {
                    x: 0,
                    y: (floor marineAgroRange) - 1
                }
                marinePos = {
                    x: 0,
                    y: 0
                } 
                marine = defaultMarine 1 marinePos
                newPlayer = player playerPos
                expected = true  

                result = playerInRange newPlayer marine
            equal expected result 

player :: Position -> Player
player pos = initialPlayer pos
