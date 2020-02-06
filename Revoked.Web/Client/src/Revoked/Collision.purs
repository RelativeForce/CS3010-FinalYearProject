module Collision where

import Prelude

import Class.Object (class Object, position, size)
import Constants (walls, hazards, mapTileSize)
import Emo8.Constants (defaultMonitorSize)
import Emo8.Types (Asset, Height, MapId, Position, Size, Width, Y, X)
import Emo8.Utils (isCollide, isMonitorCollide, isOutOfMonitor, isMapCollide)

isWallsCollide :: Asset -> MapId -> Size -> Size -> Position -> Boolean
isWallsCollide asset mId mSize = isMapCollide asset mId mSize walls

isHazardCollide :: Asset -> MapId -> Size -> Size -> Position -> Boolean
isHazardCollide asset mId mSize = isMapCollide asset mId mSize hazards

isCollideWorld :: forall a. Object a => a -> Boolean
isCollideWorld o = isCollWorld (size o) (position o)

isCollWorld :: Size -> Position -> Boolean
isCollWorld = isMonitorCollide defaultMonitorSize

isOutOfWorld :: forall a. Object a => a -> Boolean
isOutOfWorld o = isOut (size o) (position o)

isOut :: Size -> Position -> Boolean
isOut = isOutOfMonitor defaultMonitorSize

isCollideObjects :: forall a b. Object a => Object b => a -> b -> Boolean
isCollideObjects a b = isCollide (size a) (position a) (size b) (position b)

adjustY :: Y -> Y -> Height -> Y
adjustY oldY newY height = 
    if (newY > oldY) -- If moving Up
        then newY - (mod (newY + height) mapTileSize.height)
        else newY - (mod newY mapTileSize.height) + mapTileSize.height
        
adjustX :: X -> X -> Int -> Width -> X
adjustX oldX newX distance width = 
    if (newX > oldX) -- If moving Right
        then newX - (mod (distance + newX + width) mapTileSize.width)
        else newX - (mod (distance + newX) mapTileSize.width) + mapTileSize.width