module Test.Engine.Emo8.Utils ( 
    utilsTests 
) where

import Prelude

import Effect (Effect)
import Test.Engine.Emo8.Utils.UpdatePosition (updatePositionTests)
import Test.Unit.Main (runTest)

utilsTests :: Effect Unit
utilsTests = do
    -- Tests
    runTest do
        updatePositionTests
    -- Sub Modules