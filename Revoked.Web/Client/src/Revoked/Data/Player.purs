module Data.Player where

import Prelude

import Class.Object (class Object, class ObjectDraw, position)
import Constants (emoSize)
import Data.Bullet (Bullet(..))
import Emo8.Action.Draw (drawRotatedSprite)
import Emo8.Input (Input)
import Emo8.Utils (defaultMonitorSize)
import Emo8.Data.Sprite (incrementFrame)
import Data.Sprites as S
import Types (Pos)
import Emo8.Types (Sprite)

data Player = Player { 
    pos :: Pos, 
    energy :: Int, 
    appear :: Appear,
    sprite :: Sprite
}

data Appear = Stable | Forword | Backword

instance objectPlayer :: Object Player where
    size _ = emoSize
    position (Player s) = s.pos

instance objectDrawPlayer :: ObjectDraw Player where
    draw o@(Player p) = case p.appear of
            Stable -> drawRotatedSprite p.sprite (position o).x (position o).y 0
            Forword -> drawRotatedSprite p.sprite (position o).x (position o).y (- 30)
            Backword -> drawRotatedSprite p.sprite (position o).x (position o).y 30

updatePlayer :: Input -> Player -> Player
updatePlayer i (Player p) =
    Player $ p { 
        pos = newPos, 
        energy = newEnergy, 
        appear = newAppear,
        sprite = incrementFrame p.sprite
    }
    where
        newPos = updatePos i p.pos
        newEnergy = case (canEmit p.energy), (i.isW || i.isS || i.isD) of
            true, true -> 0
            true, false -> p.energy
            false, _ -> p.energy + 1
        newAppear =
            case i.isLeft, i.isRight of
                true, false -> Backword 
                false, true -> Forword
                _, _ -> Stable 

updatePos :: Input -> Pos -> Pos
updatePos i p = { x: nx, y: ny }
    where
        nx = case i.isLeft, i.isRight of
                true, false -> p.x - 4
                false, true -> p.x + 4
                _, _ -> p.x
        ny = case i.isUp, i.isDown of
                true, false -> p.y + 4
                false, true -> p.y - 4
                _, _ -> p.y

addBullet :: Input -> Player -> Array Bullet
addBullet i (Player p) =
    case canEmit p.energy of
        true | i.isW -> [ Upper { pos: p.pos } ]
        true | i.isS -> [ Downer { pos: p.pos } ]
        true | i.isD -> [ Normal { pos: p.pos } ]
        _ -> []

initialPlayer :: Player
initialPlayer = Player { 
    pos: { 
        x: 0, 
        y: defaultMonitorSize.height / 2
    }, 
    energy: 30, 
    appear: Stable,
    sprite: S.player
}

canEmit :: Int -> Boolean
canEmit energy = energy > 29