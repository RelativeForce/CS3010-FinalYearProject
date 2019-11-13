module Constants where
  
import Prelude
import Emo8.Types (ImageId, Size, TextHeight, X, Y)
import Emo8.Utils (defaultMonitorSize)
import Assets.AssetIds as Id

speed :: Int
speed = 2

emoSize :: Size
emoSize = {
    width: 32,
    height: 32
}

scoreDisplayX :: X
scoreDisplayX = (defaultMonitorSize.width - 200)

scoreDisplayY :: Y
scoreDisplayY = (defaultMonitorSize.height - 50)

scoreDisplayTextHeight :: TextHeight
scoreDisplayTextHeight = 32

mapSizeInt :: Int
mapSizeInt = 207

maxPlayerSpeedX :: Number
maxPlayerSpeedX = 4.0

maxPlayerSpeedY :: Number
maxPlayerSpeedY = 4.0

gravity :: Number
gravity = -0.1

frictionFactor :: Number
frictionFactor = 0.9

mapTileSize :: Size
mapTileSize = {
    width: 32,
    height: 32
}

mapSize :: Size
mapSize = {
    width: mapSizeInt * mapTileSize.width,
    height: mapSizeInt * mapTileSize.height
}

mapTileInMonitorSize :: Size
mapTileInMonitorSize = {
    width: defaultMonitorSize.width / mapSize.width,
    height: defaultMonitorSize.height / mapSize.height
}

boundry :: Int
boundry = 8

leftBoundry :: Int
leftBoundry = boundry * mapTileSize.width

rightBoundry :: Int
rightBoundry = defaultMonitorSize.width - (boundry * mapTileSize.width) 

walls :: Array ImageId
walls = [ 
    Id.grassTopId,
    Id.grassLeftCornerId,
    Id.grassRightCornerId,
    Id.grassLeftId,
    Id.grassRightId
]

hazards :: Array ImageId
hazards = [
    Id.toxicWasteId
]

