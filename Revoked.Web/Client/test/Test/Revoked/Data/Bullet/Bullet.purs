module Test.Revoked.Data.Bullet ( 
    bulletTests 
) where

import Prelude

import Test.Unit (TestSuite)

import Test.Revoked.Data.Bullet.ToBulletVelocity (toBulletVelocityTests)
import Test.Revoked.Data.Bullet.UpdateBullet (updateBulletTests)

bulletTests :: TestSuite
bulletTests = do
    toBulletVelocityTests
    updateBulletTests
