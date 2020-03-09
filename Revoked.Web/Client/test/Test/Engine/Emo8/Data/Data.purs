module Test.Engine.Emo8.Data ( 
    dataTests 
) where

import Test.Unit (TestSuite)

import Test.Engine.Emo8.Data.Sprite (spriteTests)

dataTests :: TestSuite
dataTests = do
    spriteTests
