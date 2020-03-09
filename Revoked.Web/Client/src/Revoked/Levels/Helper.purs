module Levels.Helper where

import Prelude

import Revoked.Assets.Sprites as S
import Constants (mapTileSize)
import Data.Goal (Goal(..))
import Data.Gun (defaultShotgunGun, defaultAssaultRifleGun)
import Data.Enemy (Enemy, defaultDroneEnemy)
import Emo8.Types (Position)

toTilePosition :: Int -> Int -> Position
toTilePosition x y = { x: x * mapTileSize.width, y: y * mapTileSize.height }

shotgunSpawn :: Position -> Goal
shotgunSpawn pos = GunPickup $ defaultShotgunGun pos 0

assaultRifleSpawn :: Position -> Goal
assaultRifleSpawn pos = GunPickup $ defaultAssaultRifleGun pos 0

ladderSection :: Position -> Int -> Goal
ladderSection ladderPos yOffset = NextLevel {
    pos: { 
        x: ladderPos.x, 
        y: ladderPos.y - yOffset
    },
    sprite: S.ladder
}

chopper :: Position -> Goal
chopper pos = NextLevel {
    pos: pos,
    sprite: S.chopper
}

healthPack :: Position -> Goal
healthPack pos = HealthPack {
    pos: pos,
    sprite: S.healthPack
}

droneRange :: Int -> Int -> Int -> { leftLimit :: Position, rightLimit :: Position }
droneRange xBlock yBlock range = { leftLimit : leftLimit, rightLimit: rightLimit }
    where
        leftLimit = toTilePosition xBlock yBlock
        rightLimit = toTilePosition (xBlock + range) yBlock

drone :: Int -> Int -> Int -> Enemy
drone xBlock yBlock range = defaultDroneEnemy 1 l r
    where
        { leftLimit : l, rightLimit: r } = droneRange xBlock yBlock range