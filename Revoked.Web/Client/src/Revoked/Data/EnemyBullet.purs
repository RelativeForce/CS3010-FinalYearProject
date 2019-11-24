module Data.EnemyBullet where

import Prelude

import Class.Object (class ObjectDraw, class Object, position, size)
import Constants (emoSize)
import Emo8.Action.Draw (emor)
import Emo8.Utils (updatePosition)
import Emo8.Data.Emoji as E
import Emo8.Types  (Position, Velocity)

data EnemyBullet = MarineBullet { 
    pos :: Position,
    velocity :: Velocity
}

instance objectEnemyBullet :: Object EnemyBullet where
    size _ = { 
        width: emoSize.width / 2, 
        height: emoSize.height / 2
    }

    position (MarineBullet s) = s.pos

    scroll offset (MarineBullet s) = MarineBullet $ s { pos = { x: s.pos.x + offset, y: s.pos.y }}

instance objectDrawEnemyBullet :: ObjectDraw EnemyBullet where
    draw o@(MarineBullet _) = emor (-40) E.pushpin (size o) (position o).x (position o).y

updateEnemyBullet :: EnemyBullet -> EnemyBullet
updateEnemyBullet (MarineBullet b) = MarineBullet $ b { pos = newPosition }
    where
        newPosition = updatePosition b.pos b.velocity
