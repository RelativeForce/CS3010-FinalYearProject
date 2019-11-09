module Data.Enemy where

import Prelude

import Class.Object (class ObjectDraw, class Object, position, size)
import Constants (emoSize, speed)
import Data.EnemyBullet (EnemyBullet(..))
import Data.Player (Player(..))
import Emo8.Action.Draw (emo)
import Emo8.Data.Emoji as E
import Emo8.Utils (defaultMonitorSize)
import Emo8.Types (Position)


data Enemy
    = Invader { pos :: Position }
    | Bee { pos :: Position }
    | Rex { pos :: Position, cnt :: Int }
    | Moi { pos :: Position, cnt :: Int }
    | Oct { pos :: Position }

instance objectEnemy :: Object Enemy where
    size _ = emoSize

    position (Invader s) = s.pos
    position (Moi s) = s.pos
    position (Bee s) = s.pos
    position (Rex s) = s.pos
    position (Oct s) = s.pos

    scroll offset (Invader s) = Invader $ s { pos = { x: s.pos.x + offset, y: s.pos.y }}
    scroll offset (Moi s) = Moi $ s { pos = { x: s.pos.x + offset, y: s.pos.y }}
    scroll offset (Bee s) = Bee $ s { pos = { x: s.pos.x + offset, y: s.pos.y }}
    scroll offset (Rex s) = Rex $ s { pos = { x: s.pos.x + offset, y: s.pos.y }}
    scroll offset (Oct s) = Oct $ s { pos = { x: s.pos.x + offset, y: s.pos.y }}

instance objectDrawEnemy :: ObjectDraw Enemy where
    draw o@(Invader _) = emo E.alienMonster (size o) (position o).x (position o).y
    draw o@(Moi _) = emo E.moai (size o) (position o).x (position o).y
    draw o@(Bee _) = emo E.honeybee (size o) (position o).x (position o).y
    draw o@(Rex _) = emo E.tRex (size o) (position o).x (position o).y
    draw o@(Oct _) = emo E.octopus (size o) (position o).x (position o).y

updateEnemy :: Player -> Enemy -> Enemy
updateEnemy p@(Player _) e@(Invader s) = Invader $ s { pos { x = s.pos.x - 3, y = s.pos.y + dy } }
    where
        v = diffVec e p
        dy
            | v.y > 0 = -1
            | v.y < 0 = 1
            | otherwise = 0
updateEnemy _ (Moi s) = Moi $ if mod s.cnt 32 < 16
        then s { pos { x = s.pos.x - 2, y = s.pos.y - 2 }, cnt = s.cnt + 1 } 
        else s { pos { x = s.pos.x - 4, y = s.pos.y + 2 } , cnt = s.cnt + 1 }
updateEnemy _ (Bee s) = Bee $ s { pos { x = s.pos.x - 6 } }
updateEnemy (Player p) (Rex s) = Rex $ if mod s.cnt 32 < 16
        then s { pos { x = s.pos.x - speed, y = s.pos.y + 4 }, cnt = s.cnt + 1 } 
        else s { pos { x = s.pos.x - speed, y = s.pos.y - 4 } , cnt = s.cnt + 1 }
updateEnemy _ (Oct s) = Oct $ s { pos { x = s.pos.x + dx } }
    where
        dx = if s.pos.x > defaultMonitorSize.width / 2 then -speed else 0

adjustEnemyPos :: Player -> Int -> Player        
adjustEnemyPos (Player p) offset = Player $ p { pos = { x: p.pos.x + offset, y: p.pos.y }}

addEnemyBullet :: Player -> Enemy -> Array EnemyBullet
addEnemyBullet _ (Moi s) = if mod s.cnt 16 == 0 then [ NormalBull { pos: s.pos } ] else []
addEnemyBullet p e@(Rex s) = if mod s.cnt 32 == 16 then [ ParseBull { pos: s.pos, vec: v', t: 0 } ] else []
    where
        v = diffVec p e
        v' = { x: v.x / 128, y: v.y / 128 } 
addEnemyBullet _ _ = []

diffVec :: forall a b. Object a => Object b => a -> b -> Position
diffVec a b = { x: (position a).x - (position b).x, y: (position a).y - (position b).y }