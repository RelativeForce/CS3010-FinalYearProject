module Emo8.FFI.ServerIO (send) where

import Data.Either (Either(..))
import Effect (Effect)

import Emo8.Types (Request)

-- | Requires `var serverLocalStore = [];` to be defined on the web page (or a preceeding JavaScript file).
-- | 
-- | Sends a Request object to via a AJAX request. This function should be repeatedly 
-- | polled. If the request does not exist in the local store when polled, the specified request will be 
-- | sent to the server and `Left "Waiting"` will be returned meaning that the request is still waiting 
-- | for a response. When the response is received from the server it is stored in the local store. When 
-- | the function is next polled the response obeject will be returned as `Right a` where `a` is the 
-- | expected response.
foreign import sendRequest :: forall a. (String -> Either String a) -> (a -> Either String a) -> Request -> Effect (Either String a)

-- | Sends a request to a server or polls the request for its result if the request 
-- | exists in the local store.
send :: forall a. Request -> Effect (Either String a)
send = sendRequest (Left) (Right)