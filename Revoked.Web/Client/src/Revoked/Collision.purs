module Revoked.Collision where

import Prelude

import Emo8.Types (Asset, Height, MapId, Position, Size, Width, Y, X)
import Emo8.Collision (isMapCollide)

import Emo8.Class.Object (class Object, position, size)
import Revoked.Constants (walls, hazards, mapTileSize, mapSizeInt, mapTileInMonitorSize, mapSize)

isCollideMapWalls :: forall a. Object a => Asset -> MapId -> X -> a -> Boolean
isCollideMapWalls asset = isCollideMap (isWallsCollide asset)

isCollideMapHazards :: forall a. Object a => Asset -> MapId -> X -> a -> Boolean
isCollideMapHazards asset = isCollideMap (isHazardCollide asset)

isCollideMap :: forall a. Object a => (MapId -> Size -> Size -> Position -> Boolean) -> MapId -> X -> a -> Boolean
isCollideMap f mapId distance o = hasCollided
    where
        offsetPosition = { x: (position o).x + distance, y: (position o).y }
        hasCollided = if -mapSizeInt * mapTileInMonitorSize.width <= distance && distance < mapSize.width
            then f mapId mapTileSize (size o) offsetPosition
            else false
            
isWallsCollide :: Asset -> MapId -> Size -> Size -> Position -> Boolean
isWallsCollide = isMapCollide walls

isHazardCollide :: Asset -> MapId -> Size -> Size -> Position -> Boolean
isHazardCollide = isMapCollide hazards

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