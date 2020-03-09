module Test.Engine.Emo8.FFI( 
    ffiTests 
) where

import Test.Unit (TestSuite)

import Test.Engine.Emo8.FFI.AudioController (audioControllerTests)

ffiTests :: TestSuite
ffiTests = do
    audioControllerTests