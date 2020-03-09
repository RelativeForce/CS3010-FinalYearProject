module Revoked.Constants where
  
import Prelude
import Emo8.Types (AssetId, Size, TextHeight, X, Y)
import Emo8.Constants (defaultMonitorSize)
import Revoked.Assets.AssetIds as Id

-- | The acceleration per frame applied to objects 
gravity :: Number
gravity = -0.5

-- | The deceleration factor per frame applied to objects 
frictionFactor :: Number
frictionFactor = 0.7

-- | The maximum length of a username 
maxUsernameLength :: Int
maxUsernameLength = 3

-- | The number of shots a infinite ammo gun has (only used a place holder)
maxShotCount :: Int
maxShotCount = 99999

-- | The max speed of the player in the x direction
maxPlayerSpeedX :: Number
maxPlayerSpeedX = 8.0

-- | The max speed of the player in the y direction
maxPlayerSpeedY :: Number
maxPlayerSpeedY = 8.0

-- | The health the player starts with
defaultPlayerHealth :: Int
defaultPlayerHealth = 5

-- | The x position of the score display
scoreDisplayX :: X
scoreDisplayX = (defaultMonitorSize.width - 200)

-- | The x position of the score display
timeDisplayX :: X
timeDisplayX = (defaultMonitorSize.width - 500)

-- | The x position of the level position
levelDisplayX :: X
levelDisplayX = 20

-- | The y position of all the constant HUD elements
hudDisplayY :: Y
hudDisplayY = (defaultMonitorSize.height - 50)

-- | The text height for all the HUD elements 
hudTextHeight :: TextHeight
hudTextHeight = 32

-- | The max number of tiles in each map in the horizontal and vertical direction.
mapSizeInt :: Int
mapSizeInt = 207

-- | The size of each map tile in pixels
mapTileSize :: Size
mapTileSize = {
    width: 32,
    height: 32
}

-- | The size of each map in the horizontal and vertical direction.
mapSize :: Size
mapSize = {
    width: mapSizeInt * mapTileSize.width,
    height: mapSizeInt * mapTileSize.height
}

-- | The size of each map tile relative to the size of the monitor.
mapTileInMonitorSize :: Size
mapTileInMonitorSize = {
    width: defaultMonitorSize.width / mapSize.width,
    height: defaultMonitorSize.height / mapSize.height
}

-- | The number of tiles from either side of the screen that will trigger 
-- | the screen to scroll.
boundry :: Int
boundry = 8

-- | The boundry that will trigger scrolling on the left side of the screen.
leftBoundry :: Int
leftBoundry = boundry * mapTileSize.width

-- | The boundry that will trigger scrolling on the right side of the screen.
rightBoundry :: Int
rightBoundry = defaultMonitorSize.width - (boundry * mapTileSize.width) 

-- | The Ids of all the map tiles that the player cannot pass through.
walls :: Array AssetId
walls = [ 
    Id.grassTopId,
    Id.grassLeftCornerId,
    Id.grassRightCornerId,
    Id.grassLeftId,
    Id.grassRightId
]

-- | The Ids of all the map tiles that will kill the player on contact.
hazards :: Array AssetId
hazards = [
    Id.toxicWasteId
]

-- | The range in pixels that a marine will begin to fire on the player
marineAgroRange :: Number
marineAgroRange = 250.0

-- | The speed that a marine walks
marineWalkSpeed :: Number
marineWalkSpeed = 2.0

-- | The speed a ghost ascends upwards
ghostAscentSpeed :: Int
ghostAscentSpeed = 5

-- | The speed a bullet moves.
bulletSpeed :: Number
bulletSpeed = 8.0

-- | The number of frames between two consecutive shots of a pistol
pistolShotCooldown :: Int
pistolShotCooldown = 10

-- | The number of shots a shotgun has by default
shotgunMagazineSize :: Int
shotgunMagazineSize = 5

-- | The number of frames between two consecutive shots of a shotgun
shotgunShotCooldown :: Int
shotgunShotCooldown = 20

-- | The number of shots a assault rifle has by default
assaultRifleMagazineSize :: Int
assaultRifleMagazineSize = 15

-- | The number of frames between two consecutive shots of an assault rifle
assaultRifleShotCooldown :: Int
assaultRifleShotCooldown = 1

-- | The amount of health given by a health pack
healthPackBonusHealth :: Int
healthPackBonusHealth = 2

-- | The points given per extra life the player has upon game completion
healthScoreMultipler :: Int
healthScoreMultipler = 5

-- | The angle incremet that drones cycle through to give the illusion of inaccuracy.
droneAccuracyDeviationIncrements :: Int
droneAccuracyDeviationIncrements = 5

-- | The speed a drone moves.
droneSpeed :: Number
droneSpeed = 2.0

-- | The number of frames between two consecutive shots of blaster
blasterShotCooldown :: Int
blasterShotCooldown = 20

-- | The speed big bertha moves
bigBerthaSpeed :: Number
bigBerthaSpeed = 2.0

-- | The range in pixels that big bertha will begin to fire on the player
bigBerthaAgroRange :: Number
bigBerthaAgroRange = 1000.0

-- | The number of frames that big bertha is immune to damage for when it reaches a health gate.
bigBerthaImmunityCooldown :: Int
bigBerthaImmunityCooldown = 120

-- | The number of frames between two consecutive shots of the big bertha mortar
bigBerthaMortarPhaseShotCooldown :: Int
bigBerthaMortarPhaseShotCooldown = 8

-- | number of frames between two consecutive shots of the big bertha machine gun phase 
bigBerthaMachineGunPhaseShotCooldown :: Int
bigBerthaMachineGunPhaseShotCooldown = 10

-- | The angle incremet that the big bertha machine gun cycles through to give the 
-- | illusion of inaccuracy.
bigBerthaMachineGunPhaseAccuracyDeviationIncrements :: Int
bigBerthaMachineGunPhaseAccuracyDeviationIncrements = 5

-- | The max offset from perfect accuracy that the big bertha machine gun can reach. 
-- | Follows a normal distribution (Inaccurate -> Accurate -> Inaccurate)
bigBerthaMachineGunPhaseMaxOffset :: Int
bigBerthaMachineGunPhaseMaxOffset = 7

-- | The number of frames between two consecutive shots of the big bertha mortar
bigBerthaCannonPhaseShotCooldown :: Int
bigBerthaCannonPhaseShotCooldown = 20