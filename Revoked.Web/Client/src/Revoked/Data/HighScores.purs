module Data.HighScores (
    PlayerScoreCreateRequestData,
    PlayerScore,
    sendPlayerScore,
    getTopScores
) where
  
import Prelude
import Data.Argonaut.Encode (encodeJson)
import Data.Argonaut.Core (stringify)
import Emo8.FFI.ServerIO (send)
import Emo8.Types(Request)

type PlayerScoreCreateRequestData = {
    username :: String,
    score :: Int,
    start :: String,
    end :: String
}

type PlayerScore = {
    username :: String,
    score :: Int,
    time :: String
}

buildSendPlayerScoreRequest :: PlayerScoreCreateRequestData -> Request
buildSendPlayerScoreRequest ps = {
    json: encodePlayerScore ps,
    url: "/?handler=StoreScore",
    method: "POST"
}

encodePlayerScore :: PlayerScoreCreateRequestData -> String
encodePlayerScore ps = stringify $ encodeJson ps

sendPlayerScore :: PlayerScoreCreateRequestData -> Boolean
sendPlayerScore ps = send $ buildSendPlayerScoreRequest ps

getTopScoresRequest :: Request
getTopScoresRequest = {
    json: "",
    url: "/?handler=TopTen",
    method: "GET"
}

getTopScores :: Array PlayerScore
getTopScores = send getTopScoresRequest