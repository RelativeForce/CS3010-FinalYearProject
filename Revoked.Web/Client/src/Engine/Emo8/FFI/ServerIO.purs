module Emo8.FFI.ServerIO (send) where

import Emo8.Types (Request)
import Data.Either (Either(..))
import Effect (Effect)

foreign import sendRequest :: forall a. (String -> Either String a) -> (a -> Either String a) -> Request -> Effect (Either String a)

send :: forall a. Request -> Effect (Either String a)
send = sendRequest (Left) (Right)