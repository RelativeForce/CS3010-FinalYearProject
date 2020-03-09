module Revoked.Data.Particle.Explosion where

import Prelude

import Emo8.Types (Position, Sprite)
import Emo8.Data.Sprite (incrementFrame, isLastFrame)

import Revoked.Assets.Sprites as S

-- | Represents the state of an explosion
type Explosion = { 
    pos :: Position,
    sprite :: Sprite
}

-- | Progresses an Explosion through its sprite animation until the end. Once there the 
-- | Explosion is moved out of the screen bounds such that it is cleaned up.
updateExplosion :: Explosion -> Explosion
updateExplosion e = e { pos = { x: e.pos.x , y: e.pos.y + deltaY }, sprite = incrementFrame e.sprite }
    where
        moveOffScreen = isLastFrame e.sprite
        deltaY = if moveOffScreen then -5000 else 0

-- | Builds a explosion with a given `Position`
defaultDroneExplosion :: Position -> Explosion
defaultDroneExplosion p = {
    pos: p,
    sprite: S.droneExplosion
}