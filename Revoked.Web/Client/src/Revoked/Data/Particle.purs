module Data.Particle where

import Prelude

import Constants (emoSize)
import Class.Object (class ObjectDraw, class Object, position, size)
import Emo8.Action.Draw (emo)
import Emo8.Data.Emoji as E
import Emo8.Types (Position)


data Particle
    = Normal
        { pos :: Position
        }

instance objectParticle :: Object Particle where
    size _ = emoSize
    position (Normal s) = s.pos

instance objectDrawParticle :: ObjectDraw Particle where
    draw o = emo E.globeWithMeridians (size o) (position o).x (position o).y

updateParticle :: Int -> Particle -> Particle
updateParticle scrollOffset (Normal s) = Normal $ s { pos { x = s.pos.x + scrollOffset, y = s.pos.y - 2 } }


initParticle :: Position -> Particle
initParticle pos = Normal { pos: pos }