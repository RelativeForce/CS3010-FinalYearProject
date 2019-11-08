module Levels where

import Data.Enemy (Enemy)
import Data.Goal (Goal)
import Emo8.Parse (RawMap)
import Emo8.Types (MapId)
import Levels.Level01 as L1

emergeTable :: MapId -> Int -> Array Enemy
emergeTable mapId distance = 
    case mapId of 
        0 -> L1.emergeTable distance
        _ -> []

allRawLevels :: Array RawMap
allRawLevels = [ L1.mapData ]

goals :: MapId -> Array Goal
goals mapId  = 
    case mapId of 
        0 -> L1.goals 
        _ -> []

levelCount :: Int
levelCount = 1