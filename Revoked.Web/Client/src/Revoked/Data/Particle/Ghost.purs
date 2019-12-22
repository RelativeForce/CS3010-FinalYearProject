module Data.Particle.Ghost where

import Prelude

import Constants (ghostAscentSpeed)
import Emo8.Types (Position, Sprite, X)
import Emo8.Data.Sprite (incrementFrame)
import Assets.Sprites as S

type Ghost = { 
    pos :: Position,
    sprite :: Sprite
}

scrollGhost :: X -> Ghost -> Ghost
scrollGhost offset g = g { pos = { x: g.pos.x + offset, y: g.pos.y }}

updateGhost :: Ghost -> Ghost
updateGhost g = g {
    pos = { x: g.pos.x , y: g.pos.y + ghostAscentSpeed },
    sprite = incrementFrame g.sprite
}

defaultMarineGhost :: Position -> Ghost
defaultMarineGhost p = {
    pos: p,
    sprite: S.marineGhost
}