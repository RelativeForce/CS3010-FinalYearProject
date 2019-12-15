module Test.Revoked.Data.Player.NewPlayerSprite ( 
    newPlayerSpriteTests 
) where

import Prelude
import Assets.Sprites as S
import Data.Player (newPlayerSprite, PlayerAppear(..))
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)

newPlayerSpriteTests :: TestSuite
newPlayerSpriteTests =
    suite "Revoked.Data.Player - newPlayerSprite" do
        test "newPlayerSpriteShouldBeMovingLeftWhenAppearIsBackwardAndPlayerIsOnFloor" do
            let 
                appear = PlayerBackward
                xSpeed = 3.2
                onFloor = true
                expectedId = S.playerLeft.id

                result = newPlayerSprite appear xSpeed onFloor

            equal expectedId result.id
        test "newPlayerSpriteShouldBeStandingLeftWhenAppearIsBackward [ OnFloor = true, xSpeed = 0.0 ]" do
            let 
                appear = PlayerBackward
                xSpeed = 0.0
                onFloor = true
                expectedId = S.playerStandingLeft.id

                result = newPlayerSprite appear xSpeed onFloor

            equal expectedId result.id
        test "newPlayerSpriteShouldBeStandingLeftWhenAppearIsBackward [ OnFloor = false, xSpeed = 0.0 ]" do
            let 
                appear = PlayerBackward
                xSpeed = 0.0
                onFloor = false
                expectedId = S.playerStandingLeft.id

                result = newPlayerSprite appear xSpeed onFloor

            equal expectedId result.id
        test "newPlayerSpriteShouldBeStandingLeftWhenAppearIsBackward [ OnFloor = false, xSpeed = 3.2 ]" do
            let 
                appear = PlayerBackward
                xSpeed = 3.2
                onFloor = false
                expectedId = S.playerStandingLeft.id

                result = newPlayerSprite appear xSpeed onFloor

            equal expectedId result.id
        test "newPlayerSpriteShouldBeMovingRightWhenAppearIsForwardAndPlayerIsOnFloor" do
            let 
                appear = PlayerForward
                xSpeed = 3.2
                onFloor = true
                expectedId = S.playerRight.id

                result = newPlayerSprite appear xSpeed onFloor

            equal expectedId result.id
        test "newPlayerSpriteShouldBeStandingRightWhenAppearIsForward [ OnFloor = true, xSpeed = 0.0 ]" do
            let 
                appear = PlayerForward
                xSpeed = 0.0
                onFloor = true
                expectedId = S.playerStandingRight.id

                result = newPlayerSprite appear xSpeed onFloor

            equal expectedId result.id
        test "newPlayerSpriteShouldBeStandingRightWhenAppearIsForward [ OnFloor = false, xSpeed = 0.0 ]" do
            let 
                appear = PlayerForward
                xSpeed = 0.0
                onFloor = false
                expectedId = S.playerStandingRight.id

                result = newPlayerSprite appear xSpeed onFloor

            equal expectedId result.id
        test "newPlayerSpriteShouldBeStandingRightWhenAppearIsForward [ OnFloor = true, xSpeed = 3.2 ]" do
            let 
                appear = PlayerForward
                xSpeed = 3.2
                onFloor = false
                expectedId = S.playerStandingRight.id

                result = newPlayerSprite appear xSpeed onFloor

            equal expectedId result.id
