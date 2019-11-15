module Emo8.Excepiton where

import Prelude

import Data.Array ((!!))
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Exception (throw)
import Emo8.Types (TileMap, MapId)

orErrMsg :: forall a. Either String a -> Effect a
orErrMsg (Right val) = pure val
orErrMsg (Left msg) = throw msg

providedMap :: forall a. Array TileMap -> MapId -> (TileMap -> Effect a) -> Effect a
providedMap ms mId op =
  case ms !! mId of
    Nothing -> throw $ "MapId " <> show mId <> " does not exist."
    Just m -> op m