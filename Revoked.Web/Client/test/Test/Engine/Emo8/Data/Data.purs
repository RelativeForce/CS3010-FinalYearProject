module Test.Engine.Emo8.Data ( 
    dataTests 
) where

import Test.Engine.Emo8.Data.Sprite (spriteTests)
import Test.Unit (TestSuite)

dataTests :: TestSuite
dataTests = do
    spriteTests
