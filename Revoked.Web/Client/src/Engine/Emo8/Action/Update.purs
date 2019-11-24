module Emo8.Action.Update where

import Prelude

import Control.Monad.Free (Free, liftF)
import Data.Array (index, length)
import Data.DateTime (DateTime)
import Data.Either (Either)
import Data.Maybe (Maybe)
import Emo8.FFI.AudioController (AudioController)
import Emo8.Types (X, Y, MapId, AssetId, Size, PlayerScore, PlayerScoreCreateRequestData)

type Update = Free UpdateF

data UpdateF n
    = RandomInt Int Int (Int -> n)
    | RandomNumber Number Number (Number -> n)
    | IsMapCollide MapId Size (Array AssetId) Size X Y (Boolean -> n)
    | NowDateTime (DateTime -> n)
    | StorePlayerScore PlayerScoreCreateRequestData (Either String Boolean -> n)
    | ListTopScores (Either String (Array PlayerScore) -> n) 
    | AddAudioStream AudioController String (AudioController -> n)
    | IsAudioStreamPlaying AudioController String (Boolean -> n)
    | StopAudioStream AudioController String (AudioController -> n)

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
isMapCollide :: MapId -> Size -> Array AssetId -> Size -> X -> Y -> Update Boolean
isMapCollide mId mSize collidableObjectIds size x y = liftF $ IsMapCollide mId mSize collidableObjectIds size x y identity

nowDateTime :: Update DateTime
nowDateTime = liftF $ NowDateTime identity

storePlayerScore :: PlayerScoreCreateRequestData -> Update (Either String Boolean)
storePlayerScore request = liftF $ StorePlayerScore request identity

listTopScores :: Update (Either String (Array PlayerScore))
listTopScores = liftF $ ListTopScores identity

addAudioStream :: AudioController -> String -> Update AudioController
addAudioStream controller src = liftF $ AddAudioStream controller src identity

isAudioStreamPlaying :: AudioController -> String -> Update Boolean
isAudioStreamPlaying controller src = liftF $ IsAudioStreamPlaying controller src identity

stopAudioStream :: AudioController -> String -> Update AudioController
stopAudioStream controller src = liftF $ StopAudioStream controller src identity