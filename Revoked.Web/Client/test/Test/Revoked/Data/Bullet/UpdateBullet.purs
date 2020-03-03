module Test.Revoked.Data.Bullet.UpdateBullet ( 
    updateBulletTests 
) where

import Prelude

import Constants (bulletSpeed, gravity)
import Emo8.Types (Velocity)
import Class.Object (position)
import Data.Int (floor)
import Data.Bullet (Bullet(..), updateBullet, newArcBullet, newLinearBullet)
import Test.Unit (TestSuite, suite, test)
import Test.Helper (equalTolerance)
import Test.Unit.Assert (equal)

updateBulletTests :: TestSuite
updateBulletTests =
    suite "Revoked.Data.Bullet - updateBullet" do
        test "SHOULD decelerate WHEN moving upwards AND is arc bullet" do
            let 
                velocity = {
                    xSpeed: 0.0,
                    ySpeed: bulletSpeed
                } 
                pos = { x: 0, y: 0 }

                bullet = newArcBullet pos velocity

                expectedVelocity = {
                    xSpeed: 0.0,
                    ySpeed: bulletSpeed + gravity
                }  
                expectedPos = { x: 0, y: floor bulletSpeed }

                result = updateBullet bullet
                resultVelocity = toVelocity result
                resultPos = position result

            equalTolerance expectedVelocity.xSpeed resultVelocity.xSpeed
            equalTolerance expectedVelocity.ySpeed resultVelocity.ySpeed
            equal expectedPos.x resultPos.x
            equal expectedPos.y resultPos.y
        test "SHOULD fall WHEN still AND is arc bullet" do
            let 
                velocity = {
                    xSpeed: 0.0,
                    ySpeed: 0.0
                } 
                pos = { x: 0, y: 0 }

                bullet = newArcBullet pos velocity

                expectedVelocity = {
                    xSpeed: 0.0,
                    ySpeed: gravity
                }  
                expectedPos = { x: 0, y: 0 }

                result = updateBullet bullet
                resultVelocity = toVelocity result
                resultPos = position result

            equalTolerance expectedVelocity.xSpeed resultVelocity.xSpeed
            equalTolerance expectedVelocity.ySpeed resultVelocity.ySpeed
            equal expectedPos.x resultPos.x
            equal expectedPos.y resultPos.y
        test "SHOULD remain still WHEN still AND is linear bullet" do
            let 
                velocity = {
                    xSpeed: 0.0,
                    ySpeed: 0.0
                } 
                pos = { x: 0, y: 0 }

                bullet = newLinearBullet pos velocity

                expectedVelocity = {
                    xSpeed: 0.0,
                    ySpeed: 0.0
                }  
                expectedPos = { x: 0, y: 0 }

                result = updateBullet bullet
                resultVelocity = toVelocity result
                resultPos = position result

            equalTolerance expectedVelocity.xSpeed resultVelocity.xSpeed
            equalTolerance expectedVelocity.ySpeed resultVelocity.ySpeed
            equal expectedPos.x resultPos.x
            equal expectedPos.y resultPos.y
        test "SHOULD follow velocity WHEN moving diagonally AND is linear bullet" do
            let 
                velocity = {
                    xSpeed: 3.0,
                    ySpeed: 5.0
                } 
                pos = { x: 0, y: 0 }

                bullet = newLinearBullet pos velocity

                expectedVelocity = {
                    xSpeed: 3.0,
                    ySpeed: 5.0
                }  
                expectedPos = { x: 3, y: 5 }

                result = updateBullet bullet
                resultVelocity = toVelocity result
                resultPos = position result

            equalTolerance expectedVelocity.xSpeed resultVelocity.xSpeed
            equalTolerance expectedVelocity.ySpeed resultVelocity.ySpeed
            equal expectedPos.x resultPos.x
            equal expectedPos.y resultPos.y

toVelocity :: Bullet -> Velocity
toVelocity (LinearBullet b) = b.velocity
toVelocity (ArcBullet b) = b.velocity
