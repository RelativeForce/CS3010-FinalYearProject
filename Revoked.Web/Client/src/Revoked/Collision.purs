module Revoked.Collision (
    isCollideMapWalls,
    isCollideMapHazards,
    adjustX,
    adjustY
) where

import Prelude

import Emo8.Types (Asset, Height, MapId, Position, Size, Width, Y, X)
import Emo8.Collision (isMapCollide)
import Emo8.Class.Object (class Object, position, size)

import Revoked.Constants (walls, hazards, mapTileSize, mapSizeInt, mapTileInMonitorSize, mapSize)

-- | Checks if a given `Object` collides with the wall objects in the map in the given Asset with the 
-- | specified `MapId` when the map is scrolled to the given `X` offset.
isCollideMapWalls :: forall a. Object a => Asset -> MapId -> X -> a -> Boolean
isCollideMapWalls = isCollideMap <<< (isMapCollide walls)

-- | Checks if a given `Object` collides with the hazard objects in the map in the given Asset with the 
-- | specified `MapId` when the map is scrolled to the given `X` offset.
isCollideMapHazards :: forall a. Object a => Asset -> MapId -> X -> a -> Boolean
isCollideMapHazards = isCollideMap <<< (isMapCollide hazards)

-- | Checks if a given `Object` has collided with the map in the given Asset with the 
-- | specified `MapId` when the map is scrolled to the given `X` offset using the given collisionCheck function.
isCollideMap :: forall a. Object a => (MapId -> Size -> Size -> Position -> Boolean) -> MapId -> X -> a -> Boolean
isCollideMap collisionCheck mapId distance o = hasCollided
    where
        offsetPosition = { x: (position o).x + distance, y: (position o).y }
        hasCollided = if -mapSizeInt * mapTileInMonitorSize.width <= distance && distance < mapSize.width
            then collisionCheck mapId mapTileSize (size o) offsetPosition
            else false

-- | Determines the `Y` coordinate of a object with the specified `Height` such that it is in 
-- | contact with the next tile in its path based on its oldY and newY values.
adjustY :: Y -> Y -> Height -> Y
adjustY oldY newY height = 
    if (newY > oldY) -- If moving Up
        then newY - (mod (newY + height) mapTileSize.height)
        else newY - (mod newY mapTileSize.height) + mapTileSize.height

-- | Determines the `X` coordinate of a object with the specified `Width` such that it is in 
-- | contact with the next tile in its path based on its oldX and newX values.
adjustX :: X -> X -> Int -> Width -> X
adjustX oldX newX distance width = 
    if (newX > oldX) -- If moving Right
        then newX - (mod (distance + newX + width) mapTileSize.width)
        else newX - (mod (distance + newX) mapTileSize.width) + mapTileSize.width