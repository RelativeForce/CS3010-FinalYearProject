module Emo8.Action.Update where

import Prelude

import Control.Monad.Free (Free, liftF)
import Data.Array (index, length)
import Data.Maybe (Maybe)
import Emo8.Types (X, Y, MapId, ImageId, Size)
import Data.DateTime (DateTime)

type Update = Free UpdateF

data UpdateF n
    = RandomInt Int Int (Int -> n)
    | RandomNumber Number Number (Number -> n)
    | IsMapCollide MapId Size (Array ImageId) Size X Y (Boolean -> n)
    | NowDateTime (DateTime -> n)

-- | Get random int.
randomInt :: Int -> Int -> Update Int
randomInt min max = liftF $ RandomInt min max identity

-- | Get random element.
randomElement :: forall a. Array a -> Update (Maybe a)
randomElement xs = index xs <$> randomInt 0 max
    where max = length xs - 1

-- | Get random number.
randomNumber :: Number -> Number -> Update Number
randomNumber min max = liftF $ RandomNumber min max identity

-- | Detect map collision.
isMapCollide :: MapId -> Size -> Array ImageId -> Size -> X -> Y -> Update Boolean
isMapCollide mId mSize collidableObjectIds size x y = liftF $ IsMapCollide mId mSize collidableObjectIds size x y identity

nowDateTime :: Update DateTime
nowDateTime = liftF $ NowDateTime identity