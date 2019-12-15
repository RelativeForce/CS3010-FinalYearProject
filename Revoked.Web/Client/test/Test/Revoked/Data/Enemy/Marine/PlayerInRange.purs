module Test.Revoked.Data.Enemy.Marine.PlayerInRange ( 
    playerInRangeTests 
) where

import Prelude

import Constants (marineAgroRange)
import Data.Enemy.Marine (playerInRange, defaultMarine)
import Data.Int (floor)
import Data.Player (Player(..), initialPlayer)
import Emo8.Types (Position)
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)

playerInRangeTests :: TestSuite
playerInRangeTests =
    suite "Revoked.Data.Enemy.Marine - playerInRange" do
        test "shouldBeInRangeWhenPlayerAndMarineHaveSamePosition" do
            let 
                playerPos = {
                    x: 3,
                    y: 5
                }
                marinePos = {
                    x: 3,
                    y: 5
                } 
                marine = defaultMarine marinePos
                newPlayer = player playerPos
                expected = true  

                result = playerInRange newPlayer marine
            equal expected result    
        test "shouldNotBeInRangeWhenPlayerAndMarineIsAtBoundryInX" do
            let 
                playerPos = {
                    x: (floor marineAgroRange),
                    y: 0
                }
                marinePos = {
                    x: 0,
                    y: 0
                } 
                marine = defaultMarine marinePos
                newPlayer = player playerPos
                expected = false  

                result = playerInRange newPlayer marine
            equal expected result   
        test "shouldBeInRangeWhenPlayerAndMarineIsWithinBoundryInX" do
            let 
                playerPos = {
                    x: (floor marineAgroRange) - 1,
                    y: 0
                }
                marinePos = {
                    x: 0,
                    y: 0
                } 
                marine = defaultMarine marinePos
                newPlayer = player playerPos
                expected = true  

                result = playerInRange newPlayer marine
            equal expected result 
        test "shouldNotBeInRangeWhenPlayerAndMarineIsAtBoundryInY" do
            let 
                playerPos = {
                    x: 0,
                    y: (floor marineAgroRange)
                }
                marinePos = {
                    x: 0,
                    y: 0
                } 
                marine = defaultMarine marinePos
                newPlayer = player playerPos
                expected = false  

                result = playerInRange newPlayer marine
            equal expected result   
        test "shouldBeInRangeWhenPlayerAndMarineIsWithinBoundryInY" do
            let 
                playerPos = {
                    x: 0,
                    y: (floor marineAgroRange) - 1
                }
                marinePos = {
                    x: 0,
                    y: 0
                } 
                marine = defaultMarine marinePos
                newPlayer = player playerPos
                expected = true  

                result = playerInRange newPlayer marine
            equal expected result 

player :: Position -> Player
player pos = Player $ p { pos = pos }
    where 
        (Player p) = initialPlayer
