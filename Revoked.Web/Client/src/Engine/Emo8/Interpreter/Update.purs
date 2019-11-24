module Emo8.Interpreter.Update where

import Prelude

import Control.Monad.Free (foldFree)
import Effect (Effect)
import Emo8.Action.Update (Update, UpdateF(..))
import Emo8.Class.Game (class Game)
import Emo8.Types (Asset, PlayerScoreCreateRequestData, PlayerScore, Request)
import Random.PseudoRandom (randomREff)
import Effect.Now (nowDateTime)
import Emo8.FFI.ServerIO (send)
import Data.Argonaut.Encode (encodeJson)
import Data.Argonaut.Core (stringify)
import Data.Either (Either)
import Emo8.FFI.AudioController (addAudioStream, isAudioStreamPlaying, stopAudioStream)

runUpdate :: forall s. Game s => Update s -> Effect s
runUpdate = foldFree interpret
  where
    interpret :: UpdateF ~> Effect
    interpret (RandomInt min max f) = f <$> randomREff min max
    interpret (RandomNumber min max f) = f <$> randomREff min max
    interpret (NowDateTime f) = f <$> nowDateTime
    interpret (StorePlayerScore request f) = f <$> sendPlayerScore request
    interpret (ListTopScores f) = f <$> listTopScores
    interpret (AddAudioStream controller src f) = f <$> addAudioStream controller src
    interpret (IsAudioStreamPlaying controller src f) = f <$> isAudioStreamPlaying controller src
    interpret (StopAudioStream controller src f) = f <$> stopAudioStream controller src

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
                