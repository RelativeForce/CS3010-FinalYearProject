module Test.Engine.Emo8.FFI( 
    ffiTests 
) where

import Prelude

import Effect (Effect)
import Test.Engine.Emo8.FFI.AudioController (audioControllerTests)

ffiTests :: Effect Unit
ffiTests = do
    -- Tests
    
    -- Sub Modules
    audioControllerTests