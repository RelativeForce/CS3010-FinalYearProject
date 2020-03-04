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
import Emo8.Input (Input, isCatchAny)
import Emo8.Utils (mkAsset)
import Emo8.Types (MapId)
import Helper (formatDifference)
import Data.Draw (drawHealth)
import Levels (allRawLevels)
import Draw (drawScrollMap, drawUsername, drawScore, drawPlayerShotCount)
import States.Play (PlayState, updatePlay, initialPlayState)
import States.Victory (VictoryState, updateVictory, initialVictoryState)
import States.Leaderboard (LeaderboardState, updateLeaderboard, initialLeaderboardState)

data State = 
    TitleScreen MapId
    | GameOver
    | Leaderboard LeaderboardState
    | Victory VictoryState
    | Play PlayState
    | Instructions 

instance gameState :: Game State where
    -- update TitleScreen state
    update _ input (TitleScreen currentStartLevel) = do
        startDateTime <- nowDateTime

        let
            startLevel = applyCheatCode input currentStartLevel
            toLeaderboard = input.catched.isL
            toInstructions = input.catched.isI
            toPlay = input.catched.isEnter

        pure $ case toPlay, toLeaderboard, toInstructions of 
            false, true, false -> Leaderboard initialLeaderboardState 
            true, false, false -> Play $ initialPlayState startLevel startDateTime
            false, false, true -> Instructions
            _, _, _ -> TitleScreen startLevel
    
    -- update GameOver state
    update _ input GameOver =
        pure $ if isCatchAny input then TitleScreen firstLevel else GameOver

    -- update Instructions state
    update _ input Instructions =
        pure $ if input.catched.isBackspace then TitleScreen firstLevel else Instructions
    
    -- update Leaderboard state
    update _ input (Leaderboard s) = do

        leaderboardStateOrNextStateId <- updateLeaderboard input s

        pure $ case leaderboardStateOrNextStateId of
            Left leaderboard -> Leaderboard leaderboard
            Right stateId -> if stateId == S.titleScreenId 
                then TitleScreen firstLevel
                else Leaderboard s

    -- update Victory state
    update _ input (Victory s) = do
       
        victoryStateOrNextStateId <- updateVictory input s

        pure $ case victoryStateOrNextStateId of
            Left victory -> Victory victory
            Right stateId -> if stateId == S.titleScreenId 
                then TitleScreen firstLevel
                else Victory s

    -- update Play state
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

    draw (TitleScreen _) = do
        drawScaledImage I.titleScreen 0 0
    draw GameOver = do
        drawScaledImage I.gameOverScreen 0 0
    draw Instructions = do
        drawScaledImage I.instructionsScreen 0 0
    draw (Victory s) = do
        drawScaledImage I.victoryScreen 0 0
        drawUsername s.username
        drawText (formatDifference s.start s.end) 27 635 140 White
        drawText (show s.score) 27 635 187 White
        drawText (if s.isWaiting then "Sending..." else "") 27 570 80 White
    draw (Leaderboard s) = do
        drawScaledImage I.leaderboardScreen 0 0
        traverse_ drawScore s.scores
        if s.isWaiting then drawText "Loading..." 27 570 80 White else pure unit
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

initialState :: State
initialState = TitleScreen firstLevel

firstLevel :: MapId
firstLevel = 0

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

calculateEndScore :: PlayState -> Int
calculateEndScore play = score
    where
        enemiesKilledScore = play.score
        healthBonus = healthScoreMultipler * ((health play.player) - 1)
        score = enemiesKilledScore + healthBonus

main :: Effect Unit
main = do
    asset <- mkAsset allRawLevels
    emo8 initialState asset defaultMonitorSize
