module Emo8.Excepiton where

import Prelude

import Data.Either (Either(..))
import Effect (Effect)
import Effect.Exception (throw)

-- | Throws a javascript error if the given `Either` is `Left`, otherwise, returns the 
-- | effect of the type that the `Right` wraps. 
orErrMsg :: forall a. Either String a -> Effect a
orErrMsg (Right val) = pure val
orErrMsg (Left msg) = throw msg