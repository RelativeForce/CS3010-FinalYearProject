module Test.Helper ( 
    equalTolerance,
    equalLength 
) where

import Prelude
import Data.Array (length)
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

-- | Assert the an array is of a given length.
equalLength :: forall a. Int -> Array a -> Test
equalLength expectedLength array =
  if expectedLength == actualLength
    then success
    else failure $ "expected length " <> show expectedLength <> ", got " <> show actualLength
  where
    actualLength = length array