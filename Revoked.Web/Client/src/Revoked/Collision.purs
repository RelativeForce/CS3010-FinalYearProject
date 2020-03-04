module Collision where

import Prelude

import Class.Object (class Object, position, size)
import Constants (walls, hazards, mapTileSize, mapSizeInt, mapTileInMonitorSize, mapSize)
import Emo8.Constants (defaultMonitorSize)
import Emo8.Types (Asset, Height, MapId, Position, Size, Width, Y, X)
import Emo8.Utils (isCollide, isMonitorCollide, isOutOfMonitor, isMapCollide)

isCollideMapWalls :: forall a. Object a => Asset -> MapId -> X -> a -> Boolean
isCollideMapWalls asset = isCollideMap (isWallsCollide asset)

isCollideMapHazards :: forall a. Object a => Asset -> MapId -> X -> a -> Boolean
isCollideMapHazards asset = isCollideMap (isHazardCollide asset)

isCollideMap :: forall a. Object a => (MapId -> Size -> Size -> Position -> Boolean) -> MapId -> X -> a -> Boolean
isCollideMap f mapId distance o = collideCondition mapId distance
    where
        collideCondition :: MapId -> X -> Boolean
        collideCondition mId d = do
            if (-mapSizeInt * mapTileInMonitorSize.width <= d && d < mapSize.width)
                then f mId mapTileSize (size o) { x: (position o).x + d, y: (position o).y }
                else false

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