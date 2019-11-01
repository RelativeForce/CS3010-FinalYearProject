module Helper where

import Prelude

import Class.Object (class Object, position, size)
import Collision (isWallsCollide, isHazardCollide)
import Constants (mapSize, mapTileWidth, mapWidth, mapTileInMonitor, leftBoundry, rightBoundry)
import Emo8.Action.Draw (Draw, drawMap)
import Emo8.Action.Update (Update)
import Emo8.Types (MapId, X, Size)
import Data.Player (Player(..))
import Types (Pos)

-- TODO: readable
drawScrollMap :: X -> MapId -> Draw Unit
drawScrollMap distance mapId = do
    drawCond mapId distance
    where
        drawCond :: MapId -> X -> Draw Unit
        drawCond mId d = do
            when (-mapSize * mapTileInMonitor <= d && d < mapWidth) $
                drawMap mId mapTileWidth (-d) 0

-- TODO: readable
isCollideMapWalls :: forall a. Object a => MapId -> X -> a -> Update Boolean
isCollideMapWalls mapId distance o = isCollide (isWallsCollide) mapId distance o

isCollideMapHazards :: forall a. Object a => MapId -> X -> a -> Update Boolean
isCollideMapHazards mapId distance o = isCollide (isHazardCollide) mapId distance o

isCollide :: forall a. Object a => (MapId -> Size -> Size -> Pos -> Update Boolean) -> MapId -> X -> a -> Update Boolean
isCollide f mapId distance o =
    collCond mapId distance
    where
        collCond :: MapId -> X -> Update Boolean
        collCond mId d = do
            if (-mapSize * mapTileInMonitor <= d && d < mapWidth)
                then f mId mapTileWidth (size o) { x: (position o).x + (d), y: (position o).y }
                else pure false

adjustMonitorDistance :: Player -> X -> X
adjustMonitorDistance (Player player) distance = 
    case isLevelAtMinimumDistance distance, isLevelAtMaximumDistance distance, isInLeftBoundry playerPos, isInRightBoundry playerPos of
        true, _, true, _ -> 0
        _, true, _, true -> mapWidth
        false, _, true, _ -> if(newXIfWithinLeftBoundry < 0) then 0 else newXIfWithinLeftBoundry
        _, false, _, true -> if(newXIfWithinRightBoundry > mapWidth) then mapWidth else newXIfWithinRightBoundry   
        _, _, _, _ -> distance
    where
        playerPos = player.pos
        playerWidth = player.sprite.width
        newXIfWithinLeftBoundry = distance + playerPos.x - leftBoundry
        newXIfWithinRightBoundry = distance + playerPos.x + playerWidth - rightBoundry

        isLevelAtMinimumDistance :: X -> Boolean
        isLevelAtMinimumDistance d = d == 0

        isLevelAtMaximumDistance :: X -> Boolean
        isLevelAtMaximumDistance d = d == mapWidth

        isInLeftBoundry :: Pos -> Boolean
        isInLeftBoundry p = p.x < leftBoundry

        isInRightBoundry :: Pos -> Boolean
        isInRightBoundry p = p.x + playerWidth > rightBoundry

adjustPlayerPos :: Player -> Int -> Player        
adjustPlayerPos (Player p) offset = Player $ p { pos = { x: p.pos.x + offset, y: p.pos.y }}