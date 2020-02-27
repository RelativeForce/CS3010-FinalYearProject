module Test.Helper ( 
    equalTolerance 
) where

import Prelude

import Test.Unit (success, failure, Test)

accuracyTolerance :: Number
accuracyTolerance = 0.001

isWithinTolerance :: Number -> Number -> Boolean
isWithinTolerance expected actual = expected <= actual + accuracyTolerance && expected >= actual - accuracyTolerance 

-- | Assert the actual value is approximately equal to the expected value.
equalTolerance :: Number -> Number -> Test
equalTolerance expected actual =
  if isWithinTolerance expected actual 
    then success
    else failure $ "expected " <> show expected <> ", got " <> show actual