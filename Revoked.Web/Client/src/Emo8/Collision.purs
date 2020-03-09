module Emo8.Collision where

import Prelude

import Data.Array (reverse, (!!))
import Data.Foldable (elem, foldr)
import Data.Maybe (Maybe(..))

import Emo8.Class.Object (class Object, position, size)
import Emo8.Types (Asset, MonitorSize, Size, Position, MapId, ScaledImage, AssetId, X, Y)
import Emo8.Constants (defaultMonitorSize)

-- | Collision detection between two objects
isCollide :: Size -> Position -> Size -> Position -> Boolean
isCollide objectSizeA posA objectSizeB posB
    = pAlx <= pBrx
    && pBlx <= pArx
    && pAby <= pBty
    && pBby <= pAty
    where
        pAlx = posA.x
        pArx = posA.x + objectSizeA.width - 1
        pAby = posA.y
        pAty = posA.y + objectSizeA.height - 1 
        pBlx = posB.x
        pBrx = posB.x + objectSizeB.width - 1
        pBby = posB.y
        pBty = posB.y + objectSizeB.height - 1 

isMapCollide :: Array AssetId -> Asset -> MapId -> Size -> Size -> Position -> Boolean
isMapCollide collidableObjectIds asset mId mSize size pos = foldr f false [lbE, rbE, ltE, rtE]
    where
        lx = pos.x
        rx = pos.x + size.width - 1
        by = pos.y
        ty = pos.y + size.height - 1
        f :: Maybe ScaledImage -> Boolean -> Boolean
        f maybeImage b = case maybeImage of
            Just img | elem img.id collidableObjectIds -> true
            _ -> b
        lbE = getMapTile asset mId (lx / mSize.width) (by / mSize.height)
        rbE = getMapTile asset mId (rx / mSize.width) (by / mSize.height)
        ltE = getMapTile asset mId (lx / mSize.width) (ty / mSize.height)
        rtE = getMapTile asset mId (rx / mSize.width) (ty / mSize.height)

getMapTile :: Asset -> MapId -> X -> Y -> Maybe ScaledImage
getMapTile ass mId xId yId = maybeTile
    where 
        map = case ass.mapData !! mId of
            Nothing -> []
            Just m -> m
        maybeAtIndex = reverse map !! yId >>= flip (!!) xId
        maybeTile = case maybeAtIndex of
            Nothing -> Nothing
            Just e -> e

-- | Collision detection if an object completely protrudes out of monitor
isOutOfMonitor :: MonitorSize -> Size -> Position -> Boolean
isOutOfMonitor ms objectSize pos
    = pos.x + objectSize.width - 1 < 0
    || pos.x > ms.width
    || pos.y + objectSize.height - 1 < 0
    || pos.y > ms.height

-- | Collision detection if an object protrudes out of monitor
isMonitorCollide :: MonitorSize -> Size -> Position -> Boolean
isMonitorCollide ms objectSize pos
    = pos.x < 0
    || pos.x + objectSize.width - 1 > ms.width
    || pos.y < 0
    || pos.y + objectSize.height - 1 > ms.height

isCollideWorld :: forall a. Object a => a -> Boolean
isCollideWorld o = isMonitorCollide defaultMonitorSize (size o) (position o)

isOutOfWorld :: forall a. Object a => a -> Boolean
isOutOfWorld o = isOutOfMonitor defaultMonitorSize (size o) (position o)

isCollideObjects :: forall a b. Object a => Object b => a -> b -> Boolean
isCollideObjects a b = isCollide (size a) (position a) (size b) (position b)