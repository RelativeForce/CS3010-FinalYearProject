module Levels where

import Data.Enemy (Enemy)
import Data.Goal (Goal)
import Emo8.Parse (RawMap)
import Emo8.Types (MapId)
import Levels.Level01 as L1
import Levels.Level02 as L2

enemies :: MapId -> Array Enemy
enemies mapId = 
    case mapId of 
        0 -> L1.enemies
        1 -> L2.enemies
        _ -> []

allRawLevels :: Array RawMap
allRawLevels = [ L1.mapData, L2.mapData ]

goals :: MapId -> Array Goal
goals mapId  = 
    case mapId of 
        0 -> L1.goals 
        1 -> L2.goals 
        _ -> []

levelCount :: Int
levelCount = 2