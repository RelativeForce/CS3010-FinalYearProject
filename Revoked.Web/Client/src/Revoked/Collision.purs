module Collision where

import Prelude
import Constants (walls, hazards, mapTileSize)
import Class.Object (class Object, position, size)
import Emo8.Types (MapId, AssetId, Position, Size, Asset, Height, Width)
import Emo8.Utils (defaultMonitorSize, isCollide, isMonitorCollide, isOutOfMonitor, isMapCollide)

isWallsCollide :: Asset -> MapId -> Size -> Size -> Position -> Boolean
isWallsCollide asset mId mSize size pos = isCollMap asset mId mSize size pos walls

isHazardCollide :: Asset -> MapId -> Size -> Size -> Position -> Boolean
isHazardCollide asset mId mSize size pos = isCollMap asset mId mSize size pos hazards

isCollMap :: Asset -> MapId -> Size -> Size -> Position -> Array AssetId -> Boolean
isCollMap asset mId mSize size {x, y} collidableObjectIds = isMapCollide asset mId mSize collidableObjectIds size x y  

isCollideWorld :: forall a. Object a => a -> Boolean
isCollideWorld o = isCollWorld (size o) (position o)

isCollWorld :: Size -> Position -> Boolean
isCollWorld size {x, y} = isMonitorCollide defaultMonitorSize size x y

isOutOfWorld :: forall a. Object a => a -> Boolean
isOutOfWorld o = isOut (size o) (position o)

isOut :: Size -> Position -> Boolean
isOut size {x, y} = isOutOfMonitor defaultMonitorSize size x y

isCollideObjects :: forall a b. Object a => Object b => a -> b -> Boolean
isCollideObjects a b = isColl (size a) (position a) (size b) (position b)

isColl :: Size -> Position -> Size -> Position -> Boolean
isColl sizeA pA sizeB pB = isCollide sizeA pA.x pA.y sizeB pB.x pB.y

adjustY :: Int -> Int -> Height -> Int
adjustY oldY newY height = 
    if (newY > oldY) -- If moving Up
        then newY - (mod (newY + height) mapTileSize.height)
        else newY - (mod newY mapTileSize.height) + mapTileSize.height
        
adjustX :: Int -> Int -> Int -> Width -> Int
adjustX oldX newX distance width = 
    if (newX > oldX) -- If moving Right
        then newX - (mod (distance + newX + width) mapTileSize.width)
        else newX - (mod (distance + newX) mapTileSize.width) + mapTileSize.width