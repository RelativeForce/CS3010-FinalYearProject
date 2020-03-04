module Constants where
  
import Prelude
import Emo8.Types (AssetId, Size, TextHeight, X, Y)
import Emo8.Constants (defaultMonitorSize)
import Assets.AssetIds as Id

-- Global

gravity :: Number
gravity = -0.5

frictionFactor :: Number
frictionFactor = 0.7

maxUsernameLength :: Int
maxUsernameLength = 3

maxShotCount :: Int
maxShotCount = 99999

-- Player

maxPlayerSpeedX :: Number
maxPlayerSpeedX = 8.0

maxPlayerSpeedY :: Number
maxPlayerSpeedY = 8.0

defaultPlayerHealth :: Int
defaultPlayerHealth = 5

-- HUD

scoreDisplayX :: X
scoreDisplayX = (defaultMonitorSize.width - 200)

timeDisplayX :: X
timeDisplayX = (defaultMonitorSize.width - 500)

levelDisplayX :: X
levelDisplayX = 20

hudDisplayY :: Y
hudDisplayY = (defaultMonitorSize.height - 50)

hudTextHeight :: TextHeight
hudTextHeight = 32

-- Map

mapSizeInt :: Int
mapSizeInt = 207

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

-- Marine

marineAgroRange :: Number
marineAgroRange = 250.0

marineWalkSpeed :: Number
marineWalkSpeed = 2.0

marineShotCooldown :: Int
marineShotCooldown = 10

ghostAscentSpeed :: Int
ghostAscentSpeed = 5

-- Bullet

bulletSpeed :: Number
bulletSpeed = 8.0

-- Pistol

pistolShotCooldown :: Int
pistolShotCooldown = 10

-- Shotgun

shotgunMagazineSize :: Int
shotgunMagazineSize = 5

shotgunShotCooldown :: Int
shotgunShotCooldown = 20

-- Assault rifle

assaultRifleMagazineSize :: Int
assaultRifleMagazineSize = 15

assaultRifleShotCooldown :: Int
assaultRifleShotCooldown = 1

-- Health

healthPackBonusHealth :: Int
healthPackBonusHealth = 2

healthScoreMultipler :: Int
healthScoreMultipler = 5

-- Drone

droneAccuracyDeviationIncrements :: Int
droneAccuracyDeviationIncrements = 5

droneSpeed :: Number
droneSpeed = 2.0

droneShotCooldown :: Int
droneShotCooldown = 20

-- Big Bertha

bigBerthaSpeed :: Number
bigBerthaSpeed = 2.0

bigBerthaAgroRange :: Number
bigBerthaAgroRange = 1000.0

bigBerthaImmunityCooldown :: Int
bigBerthaImmunityCooldown = 120

-- Big Bertha Mortar Phase

bigBerthaMortarPhaseShotCooldown :: Int
bigBerthaMortarPhaseShotCooldown = 8

-- Big Bertha Machine Gun Phase

bigBerthaMachineGunPhaseShotCooldown :: Int
bigBerthaMachineGunPhaseShotCooldown = 10

bigBerthaMachineGunPhaseAccuracyDeviationIncrements :: Int
bigBerthaMachineGunPhaseAccuracyDeviationIncrements = 5

bigBerthaMachineGunPhaseMaxDeviation :: Int
bigBerthaMachineGunPhaseMaxDeviation = 7

-- Big Bertha Cannon Phase

bigBerthaCannonPhaseShotCooldown :: Int
bigBerthaCannonPhaseShotCooldown = 20