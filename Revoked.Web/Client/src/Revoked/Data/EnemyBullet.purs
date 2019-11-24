module Data.EnemyBullet where

import Prelude

import Class.Object (class ObjectDraw, class Object)
import Emo8.Action.Draw (drawRotatedSprite)
import Emo8.Data.Sprite (incrementFrame)
import Emo8.Types (Position, Velocity, Sprite)
import Emo8.Utils (angle, updatePosition)

data EnemyBullet = MarineBullet { 
    pos :: Position,
    velocity :: Velocity,
    sprite :: Sprite
}

instance objectEnemyBullet :: Object EnemyBullet where
    size (MarineBullet s) = s.sprite.size
    position (MarineBullet s) = s.pos
    scroll offset (MarineBullet s) = MarineBullet $ s { pos = { x: s.pos.x + offset, y: s.pos.y }}

instance objectDrawEnemyBullet :: ObjectDraw EnemyBullet where
    draw (MarineBullet b) = drawRotatedSprite b.sprite b.pos.x b.pos.y (angle b.velocity)

updateEnemyBullet :: EnemyBullet -> EnemyBullet
updateEnemyBullet (MarineBullet b) = MarineBullet $ b { pos = newPosition, sprite = newSprite }
    where
        newPosition = updatePosition b.pos b.velocity
        newSprite = incrementFrame b.sprite
