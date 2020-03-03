module Test.Engine.Emo8.FFI( 
    ffiTests 
) where

import Test.Engine.Emo8.FFI.AudioController (audioControllerTests)
import Test.Unit (TestSuite)

ffiTests :: TestSuite
ffiTests = do
    audioControllerTests