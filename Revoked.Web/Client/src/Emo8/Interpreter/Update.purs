module Emo8.Interpreter.Update where

import Prelude

import Control.Monad.Free (foldFree)
import Effect (Effect)
import Effect.Now (nowDateTime)
import Data.Argonaut.Encode (encodeJson)
import Data.Argonaut.Core (stringify)
import Data.Either (Either)

import Emo8.Action.Update (Update, UpdateF(..))
import Emo8.Class.Game (class Game)
import Emo8.Types (PlayerScoreCreateRequestData, PlayerScore, Request)
import Emo8.FFI.ServerIO (send)
import Emo8.FFI.AudioController (addAudioStream, isAudioStreamPlaying, stopAudioStream, muteAudio, unmuteAudio)

runUpdate :: forall s. Game s => Update s -> Effect s
runUpdate = foldFree interpret
  where
    interpret :: UpdateF ~> Effect
    interpret (NowDateTime f) = f <$> nowDateTime
    interpret (StorePlayerScore request f) = f <$> sendPlayerScore request
    interpret (ListTopScores f) = f <$> listTopScores
    interpret (AddAudioStream controller src f) = f <$> addAudioStream controller src
    interpret (IsAudioStreamPlaying controller src f) = f <$> isAudioStreamPlaying controller src
    interpret (StopAudioStream controller src f) = f <$> stopAudioStream controller src
    interpret (MuteAudio controller f) = f <$> muteAudio controller
    interpret (UnmuteAudio controller f) = f <$> unmuteAudio controller

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
                