module Revoked.Data.Particle.Explosion where

import Prelude

import Emo8.Types (Position, Sprite, X, Size)
import Emo8.Data.Sprite (incrementFrame, isLastFrame)
import Revoked.Assets.Sprites as S

type Explosion = { 
    pos :: Position,
    sprite :: Sprite
}

explosionSize :: Explosion -> Size
explosionSize e = e.sprite.size

explosionPosition :: Explosion -> Position
explosionPosition e = e.pos

scrollExplosion :: X -> Explosion -> Explosion
scrollExplosion offset e = e { pos = { x: e.pos.x + offset, y: e.pos.y }}

updateExplosion :: Explosion -> Explosion
updateExplosion e = e { pos = { x: e.pos.x , y: e.pos.y + deltaY }, sprite = incrementFrame e.sprite }
    where
        moveOffScreen = isLastFrame e.sprite
        deltaY = if moveOffScreen then -5000 else 0

defaultDroneExplosion :: Position -> Explosion
defaultDroneExplosion p = {
    pos: p,
    sprite: S.droneExplosion
}