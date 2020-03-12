module Test.Revoked.Data.Player.NewPlayerSprite ( 
    newPlayerSpriteTests 
) where

import Prelude

import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)

import Revoked.Assets.Sprites as S
import Revoked.Data.Player (newPlayerSprite, PlayerAppear(..))

newPlayerSpriteTests :: TestSuite
newPlayerSpriteTests =
    suite "Revoked.Data.Player - newPlayerSprite" do
        test "SHOULD be moving left WHEN appear is backward AND player is on floor" do
            let 
                appear = PlayerBackward
                xSpeed = 3.2
                onFloor = true
                expectedId = S.playerLeft.id

                result = newPlayerSprite appear xSpeed onFloor

            equal expectedId result.id
        test "SHOULD be standing left WHEN appear is backward AND player is on floor AND still in x direction" do
            let 
                appear = PlayerBackward
                xSpeed = 0.0
                onFloor = true
                expectedId = S.playerStandingLeft.id

                result = newPlayerSprite appear xSpeed onFloor

            equal expectedId result.id
        test "SHOULD be standing left WHEN appear is backward AND player is not on floor AND still in x direction" do
            let 
                appear = PlayerBackward
                xSpeed = 0.0
                onFloor = false
                expectedId = S.playerStandingLeft.id

                result = newPlayerSprite appear xSpeed onFloor

            equal expectedId result.id
        test "SHOULD be standing left WHEN appear is backward AND player is not on floor AND speed is 3.2 in x direction" do
            let 
                appear = PlayerBackward
                xSpeed = 3.2
                onFloor = false
                expectedId = S.playerStandingLeft.id

                result = newPlayerSprite appear xSpeed onFloor

            equal expectedId result.id
        test "SHOULD be moving right WHEN appear is forward AND player is on floor" do
            let 
                appear = PlayerForward
                xSpeed = 3.2
                onFloor = true
                expectedId = S.playerRight.id

                result = newPlayerSprite appear xSpeed onFloor

            equal expectedId result.id
        test "SHOULD be standing right WHEN appear is forward AND player is on floor AND still in x direction" do
            let 
                appear = PlayerForward
                xSpeed = 0.0
                onFloor = true
                expectedId = S.playerStandingRight.id

                result = newPlayerSprite appear xSpeed onFloor

            equal expectedId result.id
        test "SHOULD be standing right WHEN appear is forward AND player is not on floor AND still in x direction" do
            let 
                appear = PlayerForward
                xSpeed = 0.0
                onFloor = false
                expectedId = S.playerStandingRight.id

                result = newPlayerSprite appear xSpeed onFloor

            equal expectedId result.id
        test "SHOULD be standing right WHEN appear is forward AND player is not on floor AND speed is 3.2 in x direction" do
            let 
                appear = PlayerForward
                xSpeed = 3.2
                onFloor = false
                expectedId = S.playerStandingRight.id

                result = newPlayerSprite appear xSpeed onFloor

            equal expectedId result.id
