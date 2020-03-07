module Test.Engine.Emo8.Utils ( 
    utilsTests 
) where

import Prelude

import Test.Engine.Emo8.Utils.UpdatePosition (updatePositionTests)
import Test.Engine.Emo8.Utils.Angle (angleTests)
import Test.Unit (TestSuite)

utilsTests :: TestSuite
utilsTests = do
    updatePositionTests
    angleTests