module Test.Emo8.Data ( 
    dataTests 
) where

import Test.Unit (TestSuite)

import Test.Emo8.Data.Sprite (spriteTests)

dataTests :: TestSuite
dataTests = do
    spriteTests
