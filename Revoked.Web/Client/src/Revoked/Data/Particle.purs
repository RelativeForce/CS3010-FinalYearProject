module Data.Particle where

import Prelude

import Class.Object (class ObjectDraw, class Object, position)
import Emo8.Action.Draw (drawSprite)
import Emo8.Types (Position)
import Data.Particle.Ghost (Ghost, scrollGhost, updateGhost, defaultMarineGhost, ghostSize, ghostPosition)
import Data.Particle.Explosion (Explosion, scrollExplosion, updateExplosion, defaultDroneExplosion, explosionSize, explosionPosition)

data Particle = 
    GhostParticle Ghost |
    ExplosionParticle Explosion

instance objectParticle :: Object Particle where
    size (GhostParticle g) = ghostSize g
    size (ExplosionParticle g) = explosionSize g
    position (GhostParticle g) = ghostPosition g
    position (ExplosionParticle g) = explosionPosition g
    scroll offset (GhostParticle g) = GhostParticle $ scrollGhost offset g
    scroll offset (ExplosionParticle g) = ExplosionParticle $ scrollExplosion offset g

instance objectDrawParticle :: ObjectDraw Particle where
    draw o@(GhostParticle g) = drawSprite g.sprite (position o).x (position o).y
    draw o@(ExplosionParticle g) = drawSprite g.sprite (position o).x (position o).y

updateParticle :: Particle -> Particle
updateParticle (GhostParticle g) = GhostParticle $ updateGhost g
updateParticle (ExplosionParticle g) = ExplosionParticle $ updateExplosion g

defaultGhostParticle :: Position -> Particle
defaultGhostParticle = defaultMarineGhost >>> GhostParticle

defaultExplosionParticle :: Position -> Particle
defaultExplosionParticle = defaultDroneExplosion >>> ExplosionParticle