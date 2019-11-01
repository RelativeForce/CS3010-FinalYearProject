module Constants where
  
import Prelude
import Emo8.Types (ImageId)
import Emo8.Utils (defaultMonitorSize)
import Assets.AssetIds as Id

speed :: Int
speed = 2

emoSize :: Int
emoSize = 32

mapSize :: Int
mapSize = 128

maxPlayerSpeedX :: Number
maxPlayerSpeedX = 4.0

maxPlayerSpeedY :: Number
maxPlayerSpeedY = 4.0

gravity :: Number
gravity = -0.1

frictionFactor :: Number
frictionFactor = 0.9

mapTileWidth :: Int
mapTileWidth = 32

mapWidth :: Int
mapWidth = mapSize * mapTileWidth

mapTileInMonitor :: Int
mapTileInMonitor = defaultMonitorSize.width / mapSize

walls :: Array ImageId
walls = [ 
    Id.grassTopId
]

hazards :: Array ImageId
hazards = []

