module Helper where

import Prelude

import Class.Object (class Object, position, size)
import Collision (isWallsCollide, isHazardCollide)
import Constants (mapSize, mapTileWidth, mapWidth, mapTileInMonitor)
import Emo8.Action.Draw (Draw, drawMap)
import Emo8.Action.Update (Update)
import Emo8.Types (MapId, X, Size)
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
