module Data.Particle where

import Prelude

import Class.Object (class ObjectDraw, class Object, position)
import Emo8.Action.Draw (drawSprite)
import Emo8.Types (Position)
import Data.Particle.Ghost (Ghost, scrollGhost, updateGhost, defaultMarineGhost)


data Particle = MarineGhost Ghost

instance objectParticle :: Object Particle where
    size (MarineGhost g) = g.sprite.size
    position (MarineGhost g) = g.pos
    scroll offset (MarineGhost g) = MarineGhost $ scrollGhost offset g

instance objectDrawParticle :: ObjectDraw Particle where
    draw o@(MarineGhost g) = drawSprite g.sprite (position o).x (position o).y

updateParticle :: Particle -> Particle
updateParticle (MarineGhost g) = MarineGhost $ updateGhost g

defaultMarineGhostParticle :: Position -> Particle
defaultMarineGhostParticle = defaultMarineGhost >>> MarineGhost