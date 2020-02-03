module Levels.Helper where

import Prelude


import Constants (mapTileSize)
import Emo8.Types (Position)

toTilePosition :: Int -> Int -> Position
toTilePosition x y = { x: x * mapTileSize.width, y: y * mapTileSize.height }