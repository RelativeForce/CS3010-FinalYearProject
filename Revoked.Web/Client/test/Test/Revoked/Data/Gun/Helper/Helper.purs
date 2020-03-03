module Test.Revoked.Data.Gun.Helper ( 
    helperTests 
) where

import Test.Revoked.Data.Gun.Helper.BulletVelocity (bulletVelocityTests)
import Test.Unit (TestSuite)

helperTests :: TestSuite
helperTests = do
    bulletVelocityTests
