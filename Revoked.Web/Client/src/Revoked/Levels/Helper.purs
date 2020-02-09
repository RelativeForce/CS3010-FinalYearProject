module Levels.Helper where

import Prelude

import Assets.Sprites as S
import Constants (mapTileSize)
import Data.Goal (Goal(..))
import Data.Gun (defaultShotgunGun, defaultAssaultRifleGun)
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