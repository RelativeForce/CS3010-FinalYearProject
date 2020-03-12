module Revoked.States.Leaderboard where

import Prelude

import Data.Either (Either(..))

import Emo8.Action.Update (Update, listTopScores)
import Emo8.Input (Input)
import Emo8.Types (StateId, PlayerScore)

import Revoked.States.StateIds as S

-- | Represents the leader board state
type LeaderboardState = {
    scores :: Array PlayerScore,
    isWaiting :: Boolean,
    isLoaded :: Boolean
}

-- | Update the given `LeaderboardState` based on the user input.
updateLeaderboard :: Input -> LeaderboardState -> Update (Either LeaderboardState StateId)
updateLeaderboard input s = do

    -- Load the scores if they arent loaded already or the game is waiting for the response from the server.
    let shouldLoadScores = (not s.isLoaded) || s.isWaiting

    result <- if shouldLoadScores
        then do listTopScores
        else pure $ Left "AllowInput"

    let
        backToTitleScreen = input.active.isBackspace

        -- Parse the result
        isWaiting = case result of
            Left "Waiting" -> true
            _-> false
        isLoaded = s.isLoaded || case result of
            Right response -> true
            _-> false
        scores = case result of
            Right response -> response
            _-> s.scores
        
    -- Update the state based on the input.
    pure $ case backToTitleScreen of
        true -> Right S.titleScreenId -- To title screen
        false -> Left s {
            scores = scores,
            isWaiting = isWaiting,
            isLoaded = isLoaded
        }
        
-- | The initial leader board state
initialLeaderboardState :: LeaderboardState
initialLeaderboardState = {
    scores: [],
    isWaiting: false,
    isLoaded: false
}