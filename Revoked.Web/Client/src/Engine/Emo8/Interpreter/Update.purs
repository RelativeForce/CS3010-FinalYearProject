module Emo8.Interpreter.Update where

import Prelude

import Control.Monad.Free (foldFree)
import Data.Array (reverse, (!!))
import Data.Foldable (elem, foldr)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Emo8.Action.Update (Update, UpdateF(..))
import Emo8.Class.Game (class Game)
import Emo8.Excepiton (providedMap)
import Emo8.Types (Asset, IdX, IdY, MapId, X, Y, ScaledImage, AssetId, Size, PlayerScoreCreateRequestData, PlayerScore, Request)
import Random.PseudoRandom (randomREff)
import Effect.Now (nowDateTime)
import Emo8.FFI.ServerIO (send)
import Data.Argonaut.Encode (encodeJson)
import Data.Argonaut.Core (stringify)
import Data.Either (Either)
import Emo8.FFI.AudioController (addAudioStream, isAudioStreamPlaying, stopAudioStream)

runUpdate :: forall s. Game s => Asset -> Update s -> Effect s
runUpdate ass = foldFree interpret
  where
    interpret :: UpdateF ~> Effect
    interpret (RandomInt min max f) = f <$> randomREff min max
    interpret (RandomNumber min max f) = f <$> randomREff min max
    interpret (IsMapCollide mId mSize collidableObjectIds size x y f) = f <$> isMapCollide ass mId mSize collidableObjectIds size x y
    interpret (NowDateTime f) = f <$> nowDateTime
    interpret (StorePlayerScore request f) = f <$> sendPlayerScore request
    interpret (ListTopScores f) = f <$> listTopScores
    interpret (AddAudioStream controller src f) = f <$> addAudioStream controller src
    interpret (IsAudioStreamPlaying controller src f) = f <$> isAudioStreamPlaying controller src
    interpret (StopAudioStream controller src f) = f <$> stopAudioStream controller src

-- TODO: large object detection
isMapCollide :: Asset -> MapId -> Size -> Array AssetId -> Size -> X -> Y -> Effect Boolean
isMapCollide asset mId mSize collidableObjectIds size x y = do
    lbE <- getMapTile asset mId (lx / mSize.width) (by / mSize.height)
    rbE <- getMapTile asset mId (rx / mSize.width) (by / mSize.height)
    ltE <- getMapTile asset mId (lx / mSize.width) (ty / mSize.height)
    rtE <- getMapTile asset mId (rx / mSize.width) (ty / mSize.height)
    pure $ foldr f false [lbE, rbE, ltE, rtE]
    where
        lx = x
        rx = x + size.width - 1
        by = y
        ty = y + size.height - 1
        f :: Maybe ScaledImage -> Boolean -> Boolean
        f maybeImage b = case maybeImage of
            Just img | elem img.id collidableObjectIds -> true
            _ -> b

getMapTile :: Asset -> MapId -> IdX -> IdY -> Effect (Maybe ScaledImage)
getMapTile ass mId xId yId =
    providedMap ass.mapData mId $ \em -> do
        let 
            maybeAtIndex = reverse em !! yId >>= flip (!!) xId
            maybeTile = case maybeAtIndex of
                Nothing -> Nothing
                Just e -> e
        pure $ maybeTile

buildSendPlayerScoreRequest :: PlayerScoreCreateRequestData -> Request
buildSendPlayerScoreRequest ps = {
    json: encodePlayerScore ps,
    url: "/?handler=StoreScore",
    method: "POST"
}

encodePlayerScore :: PlayerScoreCreateRequestData -> String
encodePlayerScore ps = stringify $ encodeJson ps

sendPlayerScore :: PlayerScoreCreateRequestData -> Effect (Either String Boolean)
sendPlayerScore ps = send $ buildSendPlayerScoreRequest ps

getTopScoresRequest :: Request
getTopScoresRequest = {
    json: "",
    url: "/?handler=TopTen",
    method: "GET"
}

listTopScores :: Effect (Either String (Array PlayerScore))
listTopScores = send getTopScoresRequest
                