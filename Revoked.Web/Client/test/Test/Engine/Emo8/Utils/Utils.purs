module Test.Engine.Emo8.Utils ( 
    utilsTests 
) where

import Prelude

import Effect (Effect)
import Test.Engine.Emo8.Utils.UpdatePosition (updatePositionTests)
import Test.Engine.Emo8.Utils.Angle (angleTests)
import Test.Unit.Main (runTest)

utilsTests :: Effect Unit
utilsTests = do
    -- Tests
    runTest do
        updatePositionTests
        angleTests
    -- Sub Modules