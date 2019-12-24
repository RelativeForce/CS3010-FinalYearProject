module Test.Revoked.Data.Player.Collide ( 
    collideTests 
) where

import Prelude
import Data.Player (collide, initialPlayer, Player(..))
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)
import Emo8.Types (Position)

collideTests :: TestSuite
collideTests =
    suite "Revoked.Data.Player - collide" do
        test "shouldAdjustPositionAndBeOnFloorWhenPlayerCollidesInYDirection" do
            let 
                oldPos = { x: 60, y: 65 }
                newPos = { x: 75, y: 45 }
                distance = 50
                collideX = false
                collideY = true
                collideBoth = false
                newPlayer = player newPos
                collisionCheck = mockCollisionCheck collideX collideY collideBoth oldPos

                expectedPos = { x: 75,  y: 64 }
                expectedOnFloor = true

                (Player result) = collide oldPos newPlayer distance collisionCheck

            equal expectedPos result.pos
            equal expectedOnFloor result.onFloor

        test "shouldAdjustPositionWhenPlayerCollidesInXDirection" do
            let 
                oldPos = { x: 60, y: 65 }
                newPos = { x: 75, y: 45 }
                distance = 50
                collideX = true
                collideY = false
                collideBoth = false
                newPlayer = player newPos
                collisionCheck = mockCollisionCheck collideX collideY collideBoth oldPos

                expectedPos = { x: 54,  y: 45 }
                expectedOnFloor = false

                (Player result) = collide oldPos newPlayer distance collisionCheck

            equal expectedPos result.pos
            equal expectedOnFloor result.onFloor
        test "shouldAdjustPositionAndBeOnFloorWhenPlayerCollidesInXandYandBothDirections" do
            let 
                oldPos = { x: 60, y: 65 }
                newPos = { x: 75, y: 45 }
                distance = 50
                collideX = true
                collideY = true
                collideBoth = true
                newPlayer = player newPos
                collisionCheck = mockCollisionCheck collideX collideY collideBoth oldPos

                expectedPos = { x: 54,  y: 64 }
                expectedOnFloor = true

                (Player result) = collide oldPos newPlayer distance collisionCheck

            equal expectedPos result.pos
            equal expectedOnFloor result.onFloor

        test "shouldAdjustXandReachNewYWhenPlayerCollidesInBothDirectionBothButNotXandY" do
            let 
                oldPos = { x: 60, y: 65 }
                newPos = { x: 75, y: 45 }
                distance = 50
                collideX = false
                collideY = false
                collideBoth = true
                newPlayer = player newPos
                collisionCheck = mockCollisionCheck collideX collideY collideBoth oldPos

                expectedPos = { x: 54,  y: 45 }
                expectedOnFloor = false

                (Player result) = collide oldPos newPlayer distance collisionCheck

            equal expectedPos result.pos
            equal expectedOnFloor result.onFloor


mockCollisionCheck :: Boolean -> Boolean -> Boolean -> Position -> Player -> Boolean
mockCollisionCheck collideX collideY collideBoth oldPos (Player p) = collided
    where
        xSame = oldPos.x == p.pos.x
        ySame = oldPos.y == p.pos.y
        collided = case xSame, ySame of
            true, true -> false -- Hasn't moved
            false, true -> collideX
            true, false -> collideY
            false, false -> collideBoth

player :: Position -> Player
player pos = Player $ p { pos = pos }
    where 
        (Player p) = initialPlayer
