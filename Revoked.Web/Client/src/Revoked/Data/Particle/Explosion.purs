module Data.Particle.Explosion where

import Prelude

import Emo8.Types (Position, Sprite, X, Size)
import Emo8.Data.Sprite (incrementFrame, isLastFrame)
import Assets.Sprites as S

type Explosion = { 
    pos :: Position,
    sprite :: Sprite
}

explosionSize :: Explosion -> Size
explosionSize g = g.sprite.size

explosionPosition :: Explosion -> Position
explosionPosition g = g.pos

scrollExplosion :: X -> Explosion -> Explosion
scrollExplosion offset g = g { pos = { x: g.pos.x + offset, y: g.pos.y }}

updateExplosion :: Explosion -> Explosion
updateExplosion g = g { pos = { x: g.pos.x , y: g.pos.y + deltaY }, sprite = incrementFrame g.sprite }
    where
        moveOffScreen = isLastFrame g.sprite
        deltaY = if moveOffScreen then -5000 else 0

defaultDroneExplosion :: Position -> Explosion
defaultDroneExplosion p = {
    pos: p,
    sprite: S.droneExplosion
}