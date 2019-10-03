module Data.Sprites where

import Prelude
import Emo8.Types (Sprite)
import Emo8.Data.Sprite (buildSprite)

player :: Sprite
player = buildSprite "player" 32 32 5 2 "png"