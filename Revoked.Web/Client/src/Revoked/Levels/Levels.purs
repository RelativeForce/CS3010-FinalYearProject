module Levels where

import Data.Enemy (Enemy)
import Emo8.Parse (RawMap)
import Emo8.Types (ImageId, MapId)
import Assets.AssetIds as Id
import Levels.Level01 as L1

emergeTable :: MapId -> Int -> Array Enemy
emergeTable mapId distance = 
    case mapId of 
        0 -> L1.emergeTable distance
        _ -> []

allRawLevels :: Array RawMap
allRawLevels = [ L1.mapData ]

walls :: Array ImageId
walls = [ 
    Id.playerSpriteId
]