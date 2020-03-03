module Test.Revoked.Data.Bullet ( 
    bulletTests 
) where

import Prelude

import Test.Revoked.Data.Bullet.ToBulletVelocity (toBulletVelocityTests)
import Test.Revoked.Data.Bullet.UpdateBullet (updateBulletTests)
import Test.Unit (TestSuite)

bulletTests :: TestSuite
bulletTests = do
    toBulletVelocityTests
    updateBulletTests
