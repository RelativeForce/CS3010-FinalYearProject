module Revoked.Levels where

import Emo8.Parse (RawMap)
import Emo8.Types (MapId, Position)

import Revoked.Data.Enemy (Enemy)
import Revoked.Data.Goal (Goal)
import Revoked.Levels.Level01 as L1
import Revoked.Levels.Level02 as L2
import Revoked.Levels.Level03 as L3

-- | Retrieves the initial enemies in the map with the specified `MapId`.
enemies :: MapId -> Array Enemy
enemies mapId = 
    case mapId of 
        0 -> L1.enemies
        1 -> L2.enemies
        2 -> L3.enemies
        _ -> []

-- | Retrieves the starting `Position` for the player in the map with the 
-- | specified `MapId`.
startPosition :: MapId -> Position
startPosition mapId = 
    case mapId of 
        0 -> L1.startPosition
        1 -> L2.startPosition
        2 -> L3.startPosition
        _ -> { x: 0, y: 0 }

-- | The raw levels that must be parsed into `TileMaps`
allRawLevels :: Array RawMap
allRawLevels = [ L1.mapData, L2.mapData, L3.mapData ]

-- | Retrieves the initial goals in the map with the specified `MapId`.
goals :: MapId -> Array Goal
goals mapId  = 
    case mapId of 
        0 -> L1.goals 
        1 -> L2.goals
        2 -> L3.goals
        _ -> []

-- | The number of maps in the game.
levelCount :: Int
levelCount = 3