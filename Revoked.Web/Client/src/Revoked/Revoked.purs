module Revoked where

import Prelude

import Assets.Images as I
import States.StateIds as S
import Class.Object (draw, health)
import Constants (scoreDisplayX, hudDisplayY, timeDisplayX, hudTextHeight, levelDisplayX, healthScoreMultipler)
import Data.Either (Either(..))
import Data.Foldable (traverse_)
import Effect (Effect)
import Emo8 (emo8)
import Emo8.Constants (defaultMonitorSize)
import Emo8.Action.Draw (drawScaledImage, drawText)
import Emo8.Action.Update (nowDateTime)
import Emo8.Class.Game (class Game)
import Emo8.Data.Color (Color(..))
import Emo8.Input (Input)
import Emo8.Utils (mkAsset)
import Emo8.Types (MapId)
import Helper (formatDifference)
import Data.Draw (drawHealth)
import Levels (allRawLevels)
import Draw (drawScrollMap, drawUsername, drawScore, drawPlayerShotCount)
import States.Play (PlayState, updatePlay, initialPlayState)
import States.Victory (VictoryState, updateVictory, initialVictoryState)
import States.Leaderboard (LeaderboardState, updateLeaderboard, initialLeaderboardState)

-- | The union type for representing the state of the game.
data State = 
    TitleScreen MapId
    | GameOver
    | Leaderboard LeaderboardState
    | Victory VictoryState
    | Play PlayState
    | Instructions 

-- | The update and draw instance methods for each of the data constructors in the State union type.
-- | See also Emo8.Class.Game
instance gameState :: Game State where
    -- update TitleScreen state
    update _ input (TitleScreen currentStartLevel) = do
        startDateTime <- nowDateTime

        -- Parse the input
        let
            startLevel = applyCheatCode input currentStartLevel
            toLeaderboard = input.catched.isL
            toInstructions = input.catched.isI
            toPlay = input.catched.isEnter

        -- Change state based on input
        pure $ case toPlay, toLeaderboard, toInstructions of 
            true, false, false -> Play $ initialPlayState startLevel startDateTime
            false, true, false -> Leaderboard initialLeaderboardState 
            false, false, true -> Instructions
            _, _, _ -> TitleScreen startLevel
    
    -- Update GameOver state
    update _ input GameOver =

        -- Change state based on input
        pure $ if input.catched.isEnter then TitleScreen firstLevel else GameOver

    -- Update Instructions state
    update _ input Instructions =

        -- Change state based on input
        pure $ if input.catched.isBackspace then TitleScreen firstLevel else Instructions
    
    -- Update Leaderboard state
    update _ input (Leaderboard s) = do

        -- Update leaderboard state
        leaderboardStateOrNextStateId <- updateLeaderboard input s

        -- Change state or return updated state
        pure $ case leaderboardStateOrNextStateId of
            Left leaderboard -> Leaderboard leaderboard
            Right stateId -> if stateId == S.titleScreenId 
                then initialState
                else Leaderboard s

    -- Update Victory state
    update _ input (Victory s) = do
       
        -- Update victory
        victoryStateOrNextStateId <- updateVictory input s

        -- Change state or return updated state
        pure $ case victoryStateOrNextStateId of
            Left victory -> Victory victory
            Right stateId -> if stateId == S.titleScreenId 
                then initialState
                else Victory s

    -- Update Play state
    update asset input (Play s) = do
    
        playStateOrNextStateId <- updatePlay asset input s
        now <- nowDateTime

        pure $ case playStateOrNextStateId of
            Left play -> Play play
            Right stateId -> if stateId == S.gameOverId 
                then GameOver
                else if stateId == S.victoryId 
                    then Victory $ initialVictoryState (calculateEndScore s) s.start now
                    else Play s

    -- Draw TitleScreen state
    draw (TitleScreen _) = do
        drawScaledImage I.titleScreen 0 0
    
    -- Draw GameOver state
    draw GameOver = do
        drawScaledImage I.gameOverScreen 0 0

    -- Draw Instructions state
    draw Instructions = do
        drawScaledImage I.instructionsScreen 0 0

    -- Draw Victory state
    draw (Victory s) = do
        drawScaledImage I.victoryScreen 0 0
        drawUsername s.username
        drawText (formatDifference s.start s.end) 27 635 140 White
        drawText (show s.score) 27 635 187 White
        if s.isWaiting then drawText "Sending..." 27 570 80 White else pure unit 

    -- Draw Leaderboard state
    draw (Leaderboard s) = do
        drawScaledImage I.leaderboardScreen 0 0
        traverse_ drawScore s.scores
        if s.isWaiting then drawText "Loading..." 27 570 80 White else pure unit

    -- Draw Play state
    draw (Play s) = do
        drawScaledImage I.playBackground 0 0
        drawScrollMap s.distance s.mapId
        draw s.player
        traverse_ draw s.bullets
        traverse_ draw s.enemies
        traverse_ draw s.particles
        traverse_ draw s.enemyBullets
        traverse_ draw s.goals
        drawText ("Score: " <> show s.score) hudTextHeight scoreDisplayX hudDisplayY Lime
        drawText ("Time: " <> s.elapsed) hudTextHeight timeDisplayX hudDisplayY Lime
        drawText ("Level " <> show (s.mapId + 1)) hudTextHeight levelDisplayX hudDisplayY Lime
        drawPlayerShotCount s.player
        drawHealth s.player

-- | The initial state of the game
initialState :: State
initialState = TitleScreen firstLevel

-- | The map id of the first level
firstLevel :: MapId
firstLevel = 0

-- | Determines the map Id based on the input and the currently selected map. If the user 
-- | inputs a cheat code the map id retruned will be the one accosiated with that input,
-- | otherwise, the current is returned.
applyCheatCode :: Input -> MapId -> MapId
applyCheatCode input current = levelId
    where
        levelId = if input.active.isC && input.active.isV
            then 2 -- Level 3
            else if input.active.isJ && input.active.isK
                then 1 -- Level 2
                else if input.active.isY && input.active.isU
                    then 0 -- Level 1
                    else current -- Current set

-- Calculate the final score for a given Play state
calculateEndScore :: PlayState -> Int
calculateEndScore play = score
    where
        enemiesKilledScore = play.score
        healthBonus = healthScoreMultipler * ((health play.player) - 1)
        score = enemiesKilledScore + healthBonus

-- The start method for the game
main :: Effect Unit
main = do

    -- Parse the raw levels into game Asset
    asset <- mkAsset allRawLevels

    -- Launch the game 
    emo8 initialState asset defaultMonitorSize
