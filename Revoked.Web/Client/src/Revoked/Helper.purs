module Helper where

import Prelude

import Class.Object (class Object, position, size)
import Collision (isWallsCollide, isHazardCollide, isCollWorld)
import Constants (mapSize, emoSize)
import Data.Player (Player(..))
import Emo8.Action.Draw (Draw, drawMap)
import Emo8.Action.Update (Update)
import Emo8.Types (MapId, X, Size)
import Emo8.Utils (defaultMonitorSize)
import Types (Pos)

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
mapTileWidth = 32
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

checkPlayerCollision :: Player -> Player -> X -> (Player -> Update Boolean) -> Update Player
checkPlayerCollision (Player old) (Player newPlayer) distance collisionCheck = do
    let 
        newPos = newPlayer.pos
        oldPos = old.pos
        xChangePlayer = Player $ newPlayer { 
            pos = { 
                x: newPos.x, 
                y: oldPos.y 
            }
        }
        yChangePlayer = Player $ newPlayer { 
            pos = { 
                x: oldPos.x, 
                y: newPos.y 
            }
        }
    xCollide <- collisionCheck xChangePlayer
    yCollide <- collisionCheck yChangePlayer
    bothCollide <- collisionCheck (Player newPlayer)
    let newPosition = case xCollide, yCollide, bothCollide of
            true, false, false -> { 
                x: autoCollideX oldPos.x newPos.x distance, 
                y: newPos.y 
            }
            false, true, false -> { 
                x: newPos.x, 
                y: autoCollideY oldPos.y newPos.y
            }
            false, false, true -> { 
                x: autoCollideX oldPos.x newPos.x distance, 
                y: autoCollideY oldPos.y newPos.y 
            }
            _, _, _ -> newPos
        newOnFloor = yCollide
    pure $ Player $ newPlayer { 
        pos = newPosition, 
        onFloor = newOnFloor
    }

autoCollideY :: Int -> Int -> Int
autoCollideY oldY newY = 
    if (newY > oldY) -- If moving up
        then newY - (mod newY mapTileWidth)
        else newY + (mod (newY - mapTileWidth) mapTileWidth)
        
autoCollideX :: Int -> Int -> Int -> Int
autoCollideX oldX newX distance = 
    if (newX > oldX) -- If moving Right
        then newX - (mod (distance + newX + mapTileWidth) mapTileWidth)
        else newX + (mod (distance + newX) mapTileWidth)

replacePosition :: Player -> Pos -> Player
replacePosition (Player p) pos = Player $ { 
    pos: pos, 
    onFloor: p.onFloor,
    energy: p.energy, 
    appear: p.appear,
    sprite: p.sprite,
    velocity: p.velocity
}
