module Data.EnemyBullet where

import Prelude

import Class.Object (class ObjectDraw, class Object, position, size)
import Constants (emoSize)
import Emo8.Action.Draw (emor)
import Emo8.Data.Emoji as E
import Emo8.Types  (Position)

data EnemyBullet
    = NormalBull { pos :: Position }
    | ParseBull { pos :: Position, vec :: Position, t :: Int }

instance objectEnemyBullet :: Object EnemyBullet where
    size _ = { 
        width: emoSize.width / 2, 
        height: emoSize.height / 2
    }

    position (NormalBull s) = s.pos
    position (ParseBull s) = s.pos

    scroll offset (NormalBull s) = NormalBull $ s { pos = { x: s.pos.x + offset, y: s.pos.y }}
    scroll offset (ParseBull s) = ParseBull $ s { pos = { x: s.pos.x + offset, y: s.pos.y }}

instance objectDrawEnemyBullet :: ObjectDraw EnemyBullet where
    draw o@(NormalBull _) = emor (-40) E.pushpin (size o) (position o).x (position o).y
    draw o@(ParseBull s) = emor (10 * s.t) E.hammer (size o) (position o).x (position o).y

updateEnemyBullet :: Int -> EnemyBullet -> EnemyBullet
updateEnemyBullet scrollOffset (NormalBull s) = NormalBull $ s { pos { x = s.pos.x - 6 + scrollOffset } }
updateEnemyBullet scrollOffset (ParseBull s) = ParseBull $ s { pos { x = s.pos.x + s.vec.x + scrollOffset, y = s.pos.y + s.vec.y }, t = s.t + 1 }
