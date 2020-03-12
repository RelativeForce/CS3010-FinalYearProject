module Revoked.Levels.Helper where

import Prelude

import Emo8.Types (Position)

import Revoked.Assets.Sprites as S
import Revoked.Constants (mapTileSize)
import Revoked.Data.Goal (Goal(..))
import Revoked.Data.Gun (defaultShotgunGun, defaultAssaultRifleGun)
import Revoked.Data.Enemy (Enemy, defaultDroneEnemy)

-- | Converts a tile X and Y into a `Position`
toTilePosition :: Int -> Int -> Position
toTilePosition tileX tileY = { x: tileX * mapTileSize.width, y: tileY * mapTileSize.height }

-- | Builds a shotgun weapon pickup at the specified `Position`.
shotgunSpawn :: Position -> Goal
shotgunSpawn pos = GunPickup $ defaultShotgunGun pos 0

-- | Builds a assault rifle weapon pickup at the specified `Position`.
assaultRifleSpawn :: Position -> Goal
assaultRifleSpawn pos = GunPickup $ defaultAssaultRifleGun pos 0

-- | Builds a ladder section with a given offset downward from the specified `Position`.
ladderSection :: Position -> Int -> Goal
ladderSection ladderPos yOffset = NextLevel {
    pos: { 
        x: ladderPos.x, 
        y: ladderPos.y - yOffset
    },
    sprite: S.ladder
}

-- | Builds a chopper at the specified `Position`
chopper :: Position -> Goal
chopper pos = NextLevel {
    pos: pos,
    sprite: S.chopper
}

-- | Builds a health pack at the specified `Position`
healthPack :: Position -> Goal
healthPack pos = HealthPack {
    pos: pos,
    sprite: S.healthPack
}

-- | Determines a left and right limit for a drone based on a specified tile X and Y, and the number of 
-- | blocks between it and the other limit. If the number of blocks is negative the right limit will have 
-- | a lesser x than the left limit.
droneRange :: Int -> Int -> Int -> { leftLimit :: Position, rightLimit :: Position }
droneRange tileX tileY range = { leftLimit : leftLimit, rightLimit: rightLimit }
    where
        leftLimit = toTilePosition tileX tileY
        rightLimit = toTilePosition (tileX + range) tileY

-- | Builds a drone with left and right limits specifed by one tile's X and Y, and the number of 
-- | blocks between it and the other limit.
drone :: Int -> Int -> Int -> Enemy
drone tileX tileY range = defaultDroneEnemy 1 l r
    where
        { leftLimit : l, rightLimit: r } = droneRange tileX tileY range