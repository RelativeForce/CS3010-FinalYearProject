module Test.Revoked.Data.Goal ( 
    goalTests 
) where

import Prelude

import Test.Revoked.Data.Goal.MapToHealth (mapToHealthTests)
import Test.Unit (TestSuite)

goalTests :: TestSuite
goalTests = do
    mapToHealthTests
