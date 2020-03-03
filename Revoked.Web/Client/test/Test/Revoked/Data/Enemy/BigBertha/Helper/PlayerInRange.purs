module Test.Revoked.Data.Enemy.BigBertha.Helper.PlayerInRange ( 
    playerInRangeTests 
) where

import Prelude

import Data.Enemy.BigBertha.Helper (playerInRange)
import Data.Player (initialPlayer)
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)

playerInRangeTests :: TestSuite
playerInRangeTests =
    suite "Revoked.Data.Enemy.BigBertha.Helper - playerInRange" do
        test "SHOULD be in range WHEN x distance < 1000" do
            let 
                berthaPos = {  x: 0, y: 0 }
                player = initialPlayer { x: 999, y: 0 }

                expected = true

                result = playerInRange player berthaPos
            equal expected result
        test "SHOULD not be in range WHEN x distance is 1000" do
            let 
                berthaPos = {  x: 0, y: 0 }
                player = initialPlayer { x: 1000, y: 0 }

                expected = false

                result = playerInRange player berthaPos
            equal expected result
        test "SHOULD be in range WHEN y distance < 1000" do
            let 
                berthaPos = {  x: 0, y: 0 }
                player = initialPlayer { x: 0, y: 999 }

                expected = true

                result = playerInRange player berthaPos
            equal expected result
        test "SHOULD not be in range WHEN y distance is 1000" do
            let 
                berthaPos = {  x: 0, y: 0 }
                player = initialPlayer { x: 0, y: 1000 }

                expected = false

                result = playerInRange player berthaPos
            equal expected result

