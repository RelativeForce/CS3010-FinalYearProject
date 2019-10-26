module Helper where

import Prelude

import Class.Object (class Object, position, size)
import Collision (isCollMap, isCollWorld)
import Constants (mapSize)
import Data.Player (Player(..))
import Emo8.Action.Draw (Draw, emap)
import Emo8.Action.Update (Update)
import Emo8.Types (MapId, X)
import Emo8.Utils (defaultMonitorSize)

beInMonitor :: Player -> Player -> Player
beInMonitor p np@(Player ns) = Player $ ns { pos = { x: npx, y: npy } }
    where
        size' = size np
        pos = position p
        npos = position np
        isCollX = isCollWorld size' { x: npos.x, y: pos.y }
        isCollY = isCollWorld size' { x: pos.x, y: npos.y }
        npx = case isCollX, (npos.x < pos.x) of
            true, true -> 0
            true, false -> defaultMonitorSize.width - size'
            _, _ -> npos.x
        npy = case isCollY, (npos.y < pos.y) of
            true, true -> 0
            true, false -> defaultMonitorSize.height - size'
            _, _ -> npos.y

mapTileWidth :: Int
mapTileWidth = 64
mapWidth :: Int
mapWidth = mapSize * mapTileWidth
mapTileInMonitor :: Int
mapTileInMonitor = defaultMonitorSize.width / mapSize

-- TODO: readable
drawScrollMap :: X -> MapId -> Draw Unit
drawScrollMap distance mapId = do
    drawCond mapId distance
    where
        drawCond :: MapId -> X -> Draw Unit
        drawCond mId d = do
            when (-mapSize * mapTileInMonitor <= d && d < mapWidth) $
                emap mId mapSize (-d) 0

-- TODO: readable
isCollideScrollMap :: forall a. Object a => MapId -> X -> a -> Update Boolean
isCollideScrollMap mapId distance o =
    collCond mapId distance
    where
        collCond :: MapId -> X -> Update Boolean
        collCond mId d = do
            if (-mapSize * mapTileInMonitor <= d && d < mapWidth)
                then isCollMap mId mapSize (size o) { x: (position o).x + (d), y: (position o).y }
                else pure false
