module Levels.Helper where

import Prelude

import Constants (mapTileSize)
import Emo8.Types (Position)
import Data.Goal (Goal(..))
import Data.Gun (defaultShotgunGun, defaultAssaultRifleGun)

toTilePosition :: Int -> Int -> Position
toTilePosition x y = { x: x * mapTileSize.width, y: y * mapTileSize.height }

shotgunSpawn :: Position -> Goal
shotgunSpawn pos = GunPickup $ defaultShotgunGun pos 0

assaultRifleSpawn :: Position -> Goal
assaultRifleSpawn pos = GunPickup $ defaultAssaultRifleGun pos 0