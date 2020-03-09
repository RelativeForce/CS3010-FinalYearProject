module Test.Engine.Emo8.Utils ( 
    utilsTests 
) where

import Prelude

import Test.Unit (TestSuite)

import Test.Engine.Emo8.Utils.UpdatePosition (updatePositionTests)
import Test.Engine.Emo8.Utils.Angle (angleTests)

utilsTests :: TestSuite
utilsTests = do
    updatePositionTests
    angleTests