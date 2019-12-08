module Revoked where

import Prelude

import Assets.Audio as A
import Assets.Images as I
import Class.Object (draw, position, scroll)
import Collision (isCollideObjects, isOutOfWorld)
import Constants (scoreDisplayX, scoreDisplayY, scoreDisplayTextHeight, maxUsernameLength)
import Data.Array (any, filter, partition, length, init)
import Data.Bullet (Bullet, updateBullet)
import Data.DateTime (DateTime)
import Data.Either (Either(..))
import Data.Enemy (Enemy, addEnemyBullet, updateEnemy, enemyToScore)
import Data.EnemyBullet (EnemyBullet, updateEnemyBullet)
import Data.Foldable (traverse_, sum)
import Data.Goal (Goal, updateGoal)
import Data.Maybe (Maybe(..))
import Data.Particle (Particle, initParticle, updateParticle)
import Data.Player (Player, addBullet, initialPlayer, updatePlayer)
import Data.String (joinWith)
import Effect (Effect)
import Emo8 (emo8)
import Emo8.Action.Draw (drawScaledImage, drawText)
import Emo8.Action.Update (nowDateTime, listTopScores, storePlayerScore, isAudioStreamPlaying, stopAudioStream, addAudioStream)
import Emo8.Class.Game (class Game)
import Emo8.Data.Color (Color(..))
import Emo8.FFI.AudioController (AudioController, newAudioController)
import Emo8.Input (isCatchAny, mapToCharacter)
import Emo8.Types (MapId, Score, PlayerScore)
import Emo8.Utils (defaultMonitorSize, mkAsset)
import Helper (drawScrollMap, isCollideMapWalls, isCollideMapHazards, adjustMonitorDistance, drawUsername, formatDateTime, drawScore)
import Levels (allRawLevels, enemies, goals, levelCount)
import State.Play (PlayState, updatePlay, initialPlayState)
import State.Victory (VictoryState, updateVictory, initialVictoryState)

data State = 
    TitleScreen 
    | GameOver
    | Leaderboard {
        scores :: Array PlayerScore,
        isWaiting :: Boolean,
        isLoaded :: Boolean
    }
    | Victory VictoryState
    | Play PlayState

instance gameState :: Game State where
    update _ input TitleScreen = do
        startDateTime <- nowDateTime

        let
            toLeaderboard = input.catched.isL
            toPlay = isCatchAny input

        pure $ case toPlay, toLeaderboard of 
            false, true -> initialLeaderboardState
            true, false -> Play $ initialPlayState startDateTime
            _, _ -> TitleScreen
    update _ input GameOver =
        pure $ if isCatchAny input then TitleScreen else GameOver
    update _ input (Leaderboard s) = do
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
            true -> TitleScreen
            false -> Leaderboard $ s {
                scores = scores,
                isWaiting = isWaiting,
                isLoaded = isLoaded
            }
    update _ input (Victory s) = do
       
        victoryStateOrNextStateId <- updateVictory input s

        pure $ case victoryStateOrNextStateId of
            Left victory -> Victory victory
            Right stateId -> case stateId of
                1 -> TitleScreen
                _ -> Victory s

    update asset input (Play s) = do
    
        playStateOrNextStateId <- updatePlay asset input s
        now <- nowDateTime

        pure $ case playStateOrNextStateId of
            Left play -> Play play
            Right stateId -> case stateId of
                2 -> GameOver
                4 -> Victory $ initialVictoryState s.score s.start now
                _ -> Play s

    draw TitleScreen = do
        drawScaledImage I.titleScreen 0 0
    draw GameOver = do
        drawScaledImage I.gameOverScreen 0 0
    draw (Victory s) = do
        drawScaledImage I.victoryScreen 0 0
        drawUsername s.username
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
        drawText ("Score: " <> show s.score) scoreDisplayTextHeight scoreDisplayX scoreDisplayY Lime

newLevel :: MapId -> Score -> AudioController -> DateTime -> State
newLevel mapId score audioController start = Play { 
    distance: 0, 
    player: initialPlayer, 
    bullets: [], 
    enemies: enemies mapId, 
    particles: [], 
    enemyBullets : [],
    goals: goals mapId,
    mapId: mapId,
    score: score,
    audioController: audioController,
    start: start
}

 

initialLeaderboardState :: State
initialLeaderboardState = Leaderboard {
    scores: [],
    isWaiting: false,
    isLoaded: false
}

initialState :: State
initialState = TitleScreen

main :: Effect Unit
main = do
    asset <- mkAsset allRawLevels
    emo8 initialState asset defaultMonitorSize
