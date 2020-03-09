module Test.Emo8.Utils ( 
    utilsTests 
) where

import Prelude

import Test.Unit (TestSuite)

import Test.Emo8.Utils.UpdatePosition (updatePositionTests)
import Test.Emo8.Utils.Angle (angleTests)

utilsTests :: TestSuite
utilsTests = do
    updatePositionTests
    angleTests