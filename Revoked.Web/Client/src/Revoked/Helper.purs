module Helper where

import Prelude

import Class.Object (class Object, position, size)
import Collision (isWallsCollide, isHazardCollide)
import Constants (leftBoundry, mapSizeInt, mapTileInMonitorSize, mapTileSize, mapSize, rightBoundry)
import Data.Player (Player(..))
import Emo8.Action.Draw (Draw, drawMap)
import Emo8.Action.Update (Update)
import Emo8.Types (MapId, X, Size, Position)

-- TODO: readable
drawScrollMap :: X -> MapId -> Draw Unit
drawScrollMap distance mapId = do
    drawCond mapId distance
    where
        drawCond :: MapId -> X -> Draw Unit
        drawCond mId d = do
            when (-mapSizeInt * mapTileInMonitorSize.width <= d && d < mapSize.width) $
                drawMap mId mapTileSize (-d) 0

-- TODO: readable
isCollideMapWalls :: forall a. Object a => MapId -> X -> a -> Update Boolean
isCollideMapWalls mapId distance o = isCollide (isWallsCollide) mapId distance o

isCollideMapHazards :: forall a. Object a => MapId -> X -> a -> Update Boolean
isCollideMapHazards mapId distance o = isCollide (isHazardCollide) mapId distance o

isCollide :: forall a. Object a => (MapId -> Size -> Size -> Position -> Update Boolean) -> MapId -> X -> a -> Update Boolean
isCollide f mapId distance o =
    collCond mapId distance
    where
        collCond :: MapId -> X -> Update Boolean
        collCond mId d = do
            if (-mapSizeInt * mapTileInMonitorSize.width <= d && d < mapSize.width)
                then f mId mapTileSize (size o) { x: (position o).x + d, y: (position o).y }
                else pure false

adjustMonitorDistance :: Player -> X -> X
adjustMonitorDistance (Player player) distance = 
    case isLevelAtMinimumDistance distance, isLevelAtMaximumDistance distance, isInLeftBoundry playerPos, isInRightBoundry playerPos of
        true, _, true, _ -> 0
        _, true, _, true -> mapSize.width
        false, _, true, _ -> if(newDistanceIfInLeftBoundry < 0) then 0 else newDistanceIfInLeftBoundry
        _, false, _, true -> if(newDistanceIfInRightBoundry > mapSize.width) then mapSize.width else newDistanceIfInRightBoundry   
        _, _, _, _ -> distance
    where
        playerPos = player.pos
        playerWidth = player.sprite.size.width
        newDistanceIfInLeftBoundry = distance + playerPos.x - leftBoundry
        newDistanceIfInRightBoundry = distance + playerPos.x + playerWidth - rightBoundry

        isLevelAtMinimumDistance :: X -> Boolean
        isLevelAtMinimumDistance d = d == 0

        isLevelAtMaximumDistance :: X -> Boolean
        isLevelAtMaximumDistance d = d == mapSize.width

        isInLeftBoundry :: Position -> Boolean
        isInLeftBoundry p = p.x < leftBoundry

        isInRightBoundry :: Position -> Boolean
        isInRightBoundry p = p.x + playerWidth > rightBoundry

adjustPlayerPos :: Player -> Int -> Player        
adjustPlayerPos (Player p) offset = Player $ p { pos = { x: p.pos.x + offset, y: p.pos.y }}