module Revoked.Levels where

import Data.Enemy (Enemy)
import Data.Goal (Goal)
import Emo8.Parse (RawMap)
import Emo8.Types (MapId, Position)
import Revoked.Levels.Level01 as L1
import Revoked.Levels.Level02 as L2
import Revoked.Levels.Level03 as L3

enemies :: MapId -> Array Enemy
enemies mapId = 
    case mapId of 
        0 -> L1.enemies
        1 -> L2.enemies
        2 -> L3.enemies
        _ -> []

startPosition :: MapId -> Position
startPosition mapId = 
    case mapId of 
        0 -> L1.startPosition
        1 -> L2.startPosition
        2 -> L3.startPosition
        _ -> { x: 0, y: 0 }

allRawLevels :: Array RawMap
allRawLevels = [ L1.mapData, L2.mapData, L3.mapData ]

goals :: MapId -> Array Goal
goals mapId  = 
    case mapId of 
        0 -> L1.goals 
        1 -> L2.goals
        2 -> L3.goals
        _ -> []

levelCount :: Int
levelCount = 3