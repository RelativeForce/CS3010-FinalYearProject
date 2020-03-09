module States.Victory where

import Prelude

import States.StateIds as S
import Revoked.Constants (maxUsernameLength)
import Data.Array (length, init)
import Data.Either (Either(..))
import Data.String (joinWith)
import Data.Maybe (Maybe(..))
import Emo8.Action.Update (Update, storePlayerScore)
import Data.DateTime (DateTime)
import Emo8.Input (Input, mapToCharacter)
import Emo8.Types (StateId, Score)
import Revoked.Helper (formatDateTime)

type VictoryState = {
    username :: Array String,
    score :: Int,
    inputInterval :: Int,
    start :: DateTime,
    end :: DateTime,
    isWaiting :: Boolean
}

inputInterval :: Int
inputInterval = 15

updateVictory :: Input -> VictoryState -> Update (Either VictoryState StateId)
updateVictory input s = do
    let 
        isMaxUsernameLength = maxUsernameLength == length s.username
        backSpacePressed = input.active.isBackspace
        character = mapToCharacter input
        isInvaildCharacter = character == ""
        enterPressed = input.active.isEnter
        removeCharacter = 0 < length s.username && backSpacePressed && s.inputInterval == 0
        addCharacter = not isMaxUsernameLength && not isInvaildCharacter && s.inputInterval == 0
        newUsername = case addCharacter, removeCharacter of 
            true, false -> s.username <> [ character ]
            false, true -> case init s.username of
                Just username -> username
                Nothing -> s.username
            _, _ -> s.username 
        newInputInterval = if addCharacter || removeCharacter 
            then inputInterval 
            else if s.inputInterval == 0 
                then 0 
                else s.inputInterval - 1
        request = {
            username: joinWith "" s.username,
            score: s.score,
            start: formatDateTime s.start,
            end: formatDateTime s.end
        }

    result <- if s.isWaiting || (enterPressed && isMaxUsernameLength) 
        then do storePlayerScore request 
        else pure $ Left "AllowInput"

    let
        isWaiting = case result of
            Left "Waiting" -> true
            _-> false
        submissionSuccess = case result of
            Right response -> response
            _-> false
        
    pure $ case submissionSuccess of
        true -> Right S.titleScreenId
        false -> Left $ s {
            username = newUsername,
            inputInterval = newInputInterval,
            isWaiting = isWaiting
        }

initialVictoryState :: Score -> DateTime -> DateTime -> VictoryState
initialVictoryState score start end = {
    username: [],
    score: score,
    inputInterval: 0,
    start: start,
    end: end,
    isWaiting: false
}