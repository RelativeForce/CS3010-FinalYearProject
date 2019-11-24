module Constants where
  
import Prelude
import Emo8.Types (AssetId, Size, TextHeight, X, Y)
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
maxPlayerSpeedX = 8.0

maxPlayerSpeedY :: Number
maxPlayerSpeedY = 8.0

gravity :: Number
gravity = -0.5

frictionFactor :: Number
frictionFactor = 0.7

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

walls :: Array AssetId
walls = [ 
    Id.grassTopId,
    Id.grassLeftCornerId,
    Id.grassRightCornerId,
    Id.grassLeftId,
    Id.grassRightId
]

hazards :: Array AssetId
hazards = [
    Id.toxicWasteId
]

maxUsernameLength :: Int
maxUsernameLength = 3

marineAgroRange :: Number
marineAgroRange = 250.0

marineWalkSpeed :: Number
marineWalkSpeed = 2.0

marineShotCooldown :: Int
marineShotCooldown = 10

bulletSpeed :: Number
bulletSpeed = 12.0

marineBulletSpeed :: Number
marineBulletSpeed = 8.0