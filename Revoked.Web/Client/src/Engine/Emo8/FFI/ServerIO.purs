module Emo8.FFI.ServerIO where

import Emo8.Types (Request)

foreign import send :: forall a. Request -> a