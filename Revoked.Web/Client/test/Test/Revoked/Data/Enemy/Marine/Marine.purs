module Test.Revoked.Data.Enemy.Marine ( 
    marineTests 
) where

import Test.Revoked.Data.Enemy.Marine.PlayerInRange (playerInRangeTests)
import Test.Unit (TestSuite)

marineTests :: TestSuite
marineTests = do
    playerInRangeTests