module Test.Parse.MapSum( 
    mapSumTests
) where

import Prelude

import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)
import Emo8.Parse (RawMap(..))

mapSumTests :: TestSuite
mapSumTests =
    suite "Parse - mapSum" do
        test "map" do
            equal mapSum $ mapA <> mapB

mapA :: RawMap
mapA = RawMap """
🈳🈳🈳🈳🈳🈳🈳🈳
🈳🈳🈳🈳🈳🈳🈳🈳
🈳🈳🈳🈳🈳🈳🈳🈳
🈳🈳🈳🈳🈳🈳🈳🈚
🈳🈳🈳🈳🈳🈳🈳🈚
🈳🈳🈳🈳🈳🈳🈳🈳
🈳🈳🈳🈳🈳🈳🈳🈳
🈵🈵🈵🈵🈳🈳🈳🈳
"""

mapB :: RawMap
mapB = RawMap """
🈳🈳🈳🈳🈳🈳🈳🈳
🈳🈳🈳🈳🈳🈳🈳🈳
🈳🈳🈳🈳🈳🈳🈳🈳
🈚🈳🈳🈳🈳🈳🈳🈳
🈚🈳🈳🈳🈳🈳🈳🈳
🈳🈳🈳🈳🈳🈳🈳🈳
🈳🈳🈳🈳🈳🈳🈳🈳
🈳🈳🈳🈳🈵🈵🈵🈵
"""

mapSum :: RawMap
mapSum = RawMap """
🈳🈳🈳🈳🈳🈳🈳🈳
🈳🈳🈳🈳🈳🈳🈳🈳
🈳🈳🈳🈳🈳🈳🈳🈳
🈳🈳🈳🈳🈳🈳🈳🈚
🈳🈳🈳🈳🈳🈳🈳🈚
🈳🈳🈳🈳🈳🈳🈳🈳
🈳🈳🈳🈳🈳🈳🈳🈳
🈵🈵🈵🈵🈳🈳🈳🈳
🈳🈳🈳🈳🈳🈳🈳🈳
🈳🈳🈳🈳🈳🈳🈳🈳
🈳🈳🈳🈳🈳🈳🈳🈳
🈚🈳🈳🈳🈳🈳🈳🈳
🈚🈳🈳🈳🈳🈳🈳🈳
🈳🈳🈳🈳🈳🈳🈳🈳
🈳🈳🈳🈳🈳🈳🈳🈳
🈳🈳🈳🈳🈵🈵🈵🈵
"""
