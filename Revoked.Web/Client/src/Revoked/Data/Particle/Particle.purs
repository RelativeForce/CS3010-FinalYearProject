module Revoked.Data.Particle where

import Prelude

import Emo8.Class.Object (class ObjectDraw, class Object, position)
import Emo8.Action.Draw (drawSprite)
import Emo8.Types (Position)

import Revoked.Data.Particle.Ghost (Ghost, updateGhost, defaultMarineGhost)
import Revoked.Data.Particle.Explosion (Explosion, updateExplosion, defaultDroneExplosion)

-- | Wraps the states of the different types of Particle
data Particle = 
    GhostParticle Ghost |
    ExplosionParticle Explosion

instance objectParticle :: Object Particle where
    size (GhostParticle g) = g.sprite.size
    size (ExplosionParticle e) = e.sprite.size
    position (GhostParticle g) = g.pos
    position (ExplosionParticle e) = e.pos
    scroll offset (GhostParticle g) = GhostParticle $ g { pos = { x: g.pos.x + offset, y: g.pos.y }}
    scroll offset (ExplosionParticle e) = ExplosionParticle $ e { pos = { x: e.pos.x + offset, y: e.pos.y }}

instance objectDrawParticle :: ObjectDraw Particle where
    draw o@(GhostParticle g) = drawSprite g.sprite (position o).x (position o).y
    draw o@(ExplosionParticle e) = drawSprite e.sprite (position o).x (position o).y

-- | Updates a `Particle` based on that particle types's defined update logic.
updateParticle :: Particle -> Particle
updateParticle (GhostParticle g) = GhostParticle $ updateGhost g
updateParticle (ExplosionParticle e) = ExplosionParticle $ updateExplosion e

-- | Builds a Ghost with a given `Position`
defaultGhostParticle :: Position -> Particle
defaultGhostParticle = defaultMarineGhost >>> GhostParticle

-- | Builds a Explosion with a given `Position`
defaultExplosionParticle :: Position -> Particle
defaultExplosionParticle = defaultDroneExplosion >>> ExplosionParticle