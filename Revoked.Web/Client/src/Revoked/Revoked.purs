module Revoked where

import Prelude

import Assets.Images as I
import States.StateIds as S
import Class.Object (draw)
import Constants (scoreDisplayX, hudDisplayY, timeDisplayX, hudTextHeight)
import Data.Either (Either(..))
import Data.Foldable (traverse_)
import Effect (Effect)
import Emo8 (emo8)
import Emo8.Action.Draw (drawScaledImage, drawText)
import Emo8.Action.Update (nowDateTime)
import Emo8.Class.Game (class Game)
import Emo8.Data.Color (Color(..))
import Emo8.Input (isCatchAny)
import Emo8.Utils (defaultMonitorSize, mkAsset)
import Helper (drawScrollMap, drawUsername, drawScore, formatDifference, drawPlayerShotCount)
import Levels (allRawLevels)
import States.Play (PlayState, updatePlay, initialPlayState)
import States.Victory (VictoryState, updateVictory, initialVictoryState)
import States.Leaderboard (LeaderboardState, updateLeaderboard, initialLeaderboardState)

data State = 
    TitleScreen 
    | GameOver
    | Leaderboard LeaderboardState
    | Victory VictoryState
    | Play PlayState

instance gameState :: Game State where
    -- update TitleScreen state
    update _ input TitleScreen = do
        startDateTime <- nowDateTime

        let
            toLeaderboard = input.catched.isL
            toPlay = isCatchAny input

        pure $ case toPlay, toLeaderboard of 
            false, true -> Leaderboard initialLeaderboardState
            true, false -> Play $ initialPlayState startDateTime
            _, _ -> TitleScreen
    
    -- update GameOver state
    update _ input GameOver =
        pure $ if isCatchAny input then TitleScreen else GameOver
    
    -- update Leaderboard state
    update _ input (Leaderboard s) = do

        leaderboardStateOrNextStateId <- updateLeaderboard input s

        pure $ case leaderboardStateOrNextStateId of
            Left leaderboard -> Leaderboard leaderboard
            Right stateId -> if stateId == S.titleScreenId 
                then TitleScreen
                else Leaderboard s

    -- update Victory state
    update _ input (Victory s) = do
       
        victoryStateOrNextStateId <- updateVictory input s

        pure $ case victoryStateOrNextStateId of
            Left victory -> Victory victory
            Right stateId -> if stateId == S.titleScreenId 
                then TitleScreen
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
                    then Victory $ initialVictoryState s.score s.start now
                    else Play s

    draw TitleScreen = do
        drawScaledImage I.titleScreen 0 0
    draw GameOver = do
        drawScaledImage I.gameOverScreen 0 0
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
        drawScaledImage I.blackBackground 0 0
        drawScrollMap s.distance s.mapId
        draw s.player
        traverse_ draw s.bullets
        traverse_ draw s.enemies
        traverse_ draw s.particles
        traverse_ draw s.enemyBullets
        traverse_ draw s.goals
        drawText ("Score: " <> show s.score) hudTextHeight scoreDisplayX hudDisplayY Lime
        drawText ("Time: " <> s.elapsed) hudTextHeight timeDisplayX hudDisplayY Lime
        drawPlayerShotCount s.player

initialState :: State
initialState = TitleScreen

main :: Effect Unit
main = do
    asset <- mkAsset allRawLevels
    emo8 initialState asset defaultMonitorSize
