module States.Leaderboard where

import Prelude

import States.StateIds as S
import Data.Array (length)
import Data.Either (Either(..))
import Emo8.Action.Update (Update, listTopScores)
import Emo8.Input (Input)
import Emo8.Types (StateId, PlayerScore)

type LeaderboardState = {
    scores :: Array PlayerScore,
    isWaiting :: Boolean,
    isLoaded :: Boolean
}

updateLeaderboard :: Input -> LeaderboardState -> Update (Either LeaderboardState StateId)
updateLeaderboard input s = do
    let 
        hasNoScores = 0 == length s.scores
        shouldLoadScores = not s.isLoaded && (s.isWaiting || hasNoScores)  

    result <- if shouldLoadScores
        then do listTopScores
        else pure $ Left "AllowInput"

    let
        backToTitleScreen = input.catched.isBackspace
        isWaiting = case result of
            Left "Waiting" -> true
            _-> false
        isLoaded = case result of
            Right response -> true
            _-> false
        scores = case result of
            Right response -> response
            _-> s.scores
        
    pure $ case backToTitleScreen of
        true -> Right S.titleScreenId
        false -> Left s {
            scores = scores,
            isWaiting = isWaiting,
            isLoaded = isLoaded
        }
        
initialLeaderboardState :: LeaderboardState
initialLeaderboardState = {
    scores: [],
    isWaiting: false,
    isLoaded: false
}