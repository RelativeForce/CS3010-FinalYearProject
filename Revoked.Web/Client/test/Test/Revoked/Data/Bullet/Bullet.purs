module Test.Revoked.Data.Bullet ( 
    bulletTests 
) where

import Test.Revoked.Data.Bullet.ToBulletVelocity (toBulletVelocityTests)
import Test.Unit (TestSuite)

bulletTests :: TestSuite
bulletTests = do
    toBulletVelocityTests
