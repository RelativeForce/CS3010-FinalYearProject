module Collision where

import Levels (walls, hazards)
import Class.Object (class Object, position, size)
import Control.Monad.Gen (Size)
import Emo8.Action.Update (Update, isMapCollide)
import Emo8.Types (MapId, ImageId)
import Emo8.Utils (defaultMonitorSize, isCollide, isMonitorCollide, isOutOfMonitor)
import Types (Pos)

isWallsCollide :: MapId -> Size -> Size -> Pos -> Update Boolean
isWallsCollide mId mSize size pos = isCollMap mId mSize size pos walls

isHazardCollide :: MapId -> Size -> Size -> Pos -> Update Boolean
isHazardCollide mId mSize size pos = isCollMap mId mSize size pos hazards

isCollMap :: MapId -> Size -> Size -> Pos -> Array ImageId -> Update Boolean
isCollMap mId mSize size {x, y} collidableObjectIds = isMapCollide mId mSize collidableObjectIds size x y  

isCollideWorld :: forall a. Object a => a -> Boolean
isCollideWorld o = isCollWorld (size o) (position o)

isCollWorld :: Size -> Pos -> Boolean
isCollWorld size {x, y} = isMonitorCollide defaultMonitorSize size x y

isOutOfWorld :: forall a. Object a => a -> Boolean
isOutOfWorld o = isOut (size o) (position o)

isOut :: Size -> Pos -> Boolean
isOut size {x, y} = isOutOfMonitor defaultMonitorSize size x y

isCollideObjects :: forall a b. Object a => Object b => a -> b -> Boolean
isCollideObjects a b = isColl (size a) (position a) (size b) (position b)

isColl :: Size -> Pos -> Size -> Pos -> Boolean
isColl sizeA pA sizeB pB = isCollide sizeA pA.x pA.y sizeB pB.x pB.y
