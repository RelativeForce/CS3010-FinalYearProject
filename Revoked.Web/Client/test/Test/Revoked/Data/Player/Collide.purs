module Test.Revoked.Data.Player.Collide ( 
    collideTests 
) where

import Prelude

import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)

import Emo8.Types (Position)

import Revoked.Data.Player (collide, initialPlayer, Player(..), PlayerState)

collideTests :: TestSuite
collideTests =
    suite "Revoked.Data.Player - collide" do
        test "SHOULD adjust position AND be on floor WHEN player collides in Y drection" do
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

                result = collide oldPos newPlayer distance collisionCheck

            equal expectedPos result.pos
            equal expectedOnFloor result.onFloor

        test "SHOULD adjust position WHEN player collides in X direction" do
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

                result = collide oldPos newPlayer distance collisionCheck

            equal expectedPos result.pos
            equal expectedOnFloor result.onFloor
        test "SHOULD adjust position AND be on floor WHEN player collides in X AND Y AND both directions" do
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

                result = collide oldPos newPlayer distance collisionCheck

            equal expectedPos result.pos
            equal expectedOnFloor result.onFloor

        test "SHOULD adjust X and reach new Y WHEN player collides in both direction both but not X OR Y" do
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

                result = collide oldPos newPlayer distance collisionCheck

            equal expectedPos result.pos
            equal expectedOnFloor result.onFloor


mockCollisionCheck :: Boolean -> Boolean -> Boolean -> Position -> PlayerState -> Boolean
mockCollisionCheck collideX collideY collideBoth oldPos p = collided
    where
        xSame = oldPos.x == p.pos.x
        ySame = oldPos.y == p.pos.y
        collided = case xSame, ySame of
            true, true -> false -- Hasn't moved
            false, true -> collideX
            true, false -> collideY
            false, false -> collideBoth

player :: Position -> PlayerState
player pos = p
    where
        (Player p) = initialPlayer pos 
