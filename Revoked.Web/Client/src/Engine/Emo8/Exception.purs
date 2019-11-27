module Emo8.Excepiton where

import Prelude

import Data.Either (Either(..))
import Effect (Effect)
import Effect.Exception (throw)

orErrMsg :: forall a. Either String a -> Effect a
orErrMsg (Right val) = pure val
orErrMsg (Left msg) = throw msg