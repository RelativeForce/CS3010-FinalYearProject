module Emo8.FFI.ServerIO where

import Emo8.Types (Request)
import Data.Either (Either(..))

foreign import sendRequest :: forall a. (String -> Either String a) -> (a -> Either String a) -> Request -> Either String a

send :: forall a. Request -> Either String a
send = sendRequest (Left) (Right)