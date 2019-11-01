module Emo8.Interpreter.Update where

import Prelude

import Control.Monad.Free (foldFree)
import Control.Monad.Gen (Size)
import Data.Array (reverse, (!!))
import Data.Foldable (elem, foldr)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Emo8.Action.Update (Update, UpdateF(..))
import Emo8.Class.Game (class Game)
import Emo8.Excepiton (providedMap)
import Emo8.Types (Asset, IdX, IdY, MapId, X, Y, ScaledImage, ImageId)
import Random.PseudoRandom (randomREff)

runUpdate :: forall s. Game s => Asset -> Update s -> Effect s
runUpdate ass = foldFree interpret
  where
    interpret :: UpdateF ~> Effect
    interpret (RandomInt min max f) = f <$> randomREff min max
    interpret (RandomNumber min max f) = f <$> randomREff min max
    interpret (IsMapCollide mId mSize collidableObjectIds size x y f) = f <$> isMapCollide ass mId mSize collidableObjectIds size x y

-- TODO: large object detection
isMapCollide :: Asset -> MapId -> Size -> Array ImageId -> Size -> X -> Y -> Effect Boolean
isMapCollide asset mId mSize collidableObjectIds size x y = do
    lbE <- getMapTile asset mId (lx / mSize) (by / mSize)
    rbE <- getMapTile asset mId (rx / mSize) (by / mSize)
    ltE <- getMapTile asset mId (lx / mSize) (ty / mSize)
    rtE <- getMapTile asset mId (rx / mSize) (ty / mSize)
    pure $ foldr f false [lbE, rbE, ltE, rtE]
    where
        lx = x
        rx = x + size - 1
        by = y
        ty = y + size - 1
        f :: Maybe ScaledImage -> Boolean -> Boolean
        f maybeImage b = case maybeImage of
            Just img | elem img.id collidableObjectIds -> true
            _ -> b

getMapTile :: Asset -> MapId -> IdX -> IdY -> Effect (Maybe ScaledImage)
getMapTile ass mId xId yId =
    providedMap ass.mapData mId $ \em -> do
        let 
            maybeAtIndex = reverse em !! yId >>= flip (!!) xId
            maybeTile = case maybeAtIndex of
                Nothing -> Nothing
                Just e -> e
        pure $ maybeTile
                