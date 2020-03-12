module Revoked.Data.Particle.Ghost where

import Prelude

import Emo8.Types (Position, Sprite)
import Emo8.Data.Sprite (incrementFrame)

import Revoked.Constants (ghostAscentSpeed)
import Revoked.Assets.Sprites as S

-- | Represents the state of a Ghost
type Ghost = { 
    pos :: Position,
    sprite :: Sprite
}

-- | Asends the specified `Ghost` at the constant rate.
updateGhost :: Ghost -> Ghost
updateGhost g = g {
    pos = { x: g.pos.x , y: g.pos.y + ghostAscentSpeed },
    sprite = incrementFrame g.sprite
}

-- | Builds a default ghost
defaultMarineGhost :: Position -> Ghost
defaultMarineGhost p = {
    pos: p,
    sprite: S.marineGhost
}