module Revoked where

import Prelude

import Assets.Audio as A
import Assets.Images as I
import Class.Object (draw, position, scroll)
import Collision (isCollideObjects, isOutOfWorld)
import Constants (scoreDisplayX, scoreDisplayY, scoreDisplayTextHeight, maxUsernameLength)
import Data.Array (any, filter, partition, length, init)
import Data.Bullet (Bullet, updateBullet)
import Data.Enemy (Enemy, addEnemyBullet, updateEnemy, enemyToScore)
import Data.EnemyBullet (EnemyBullet, updateEnemyBullet)
import Data.Foldable (traverse_, sum)
import Data.Either (Either(..))
import Data.String (joinWith)
import Data.Goal (Goal, updateGoal)
import Data.Maybe (Maybe(..))
import Data.Particle (Particle, initParticle, updateParticle)
import Data.Player (Player, addBullet, initialPlayer, updatePlayer)
import Effect (Effect)
import Emo8 (emo8)
import Emo8.Action.Draw (drawScaledImage, drawText)
import Emo8.Action.Update (nowDateTime, listTopScores, storePlayerScore, isAudioStreamPlaying, stopAudioStream, addAudioStream)
import Emo8.Class.Game (class Game)
import Emo8.Data.Color (Color(..))
import Data.DateTime (DateTime)
import Emo8.FFI.AudioController (AudioController, newAudioController)
import Emo8.Input (isCatchAny, mapToCharacter)
import Emo8.Types (MapId, Score, PlayerScore)
import Emo8.Utils (defaultMonitorSize, mkAsset)
import Helper (
    drawScrollMap, 
    isCollideMapWalls, 
    isCollideMapHazards, 
    adjustMonitorDistance, 
    drawUsername, 
    formatDateTime, 
    drawScore
)
import Levels (allRawLevels, enemies, goals, levelCount)
import State.Play (PlayState, updatePlay, initialPlayState)

data State = 
    TitleScreen 
    | GameOver
    | Leaderboard {
        scores :: Array PlayerScore,
        isWaiting :: Boolean,
        isLoaded :: Boolean
    }
    | Victory {
        username :: Array String,
        score :: Int,
        inputInterval :: Int,
        start :: DateTime,
        end :: DateTime,
        isWaiting :: Boolean
    }
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
            newInputInterval = if addCharacter || removeCharacter then 15 else if s.inputInterval == 0 then 0 else s.inputInterval - 1
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
            true -> TitleScreen
            false -> Victory $ s {
                username = newUsername,
                inputInterval = newInputInterval,
                isWaiting = isWaiting
            }
    update asset input (Play s) = do
    
        playStateOrNextStateId <- updatePlay asset input s
        now <- nowDateTime

        pure $ case playStateOrNextStateId of
            Left play -> Play play
            Right stateId -> case stateId of
                2 -> GameOver
                4 -> initialVictoryState s.score s.start now
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

initialVictoryState :: Score -> DateTime -> DateTime -> State
initialVictoryState score start end = Victory {
    username: [],
    score: score,
    inputInterval: 0,
    start: start,
    end: end,
    isWaiting: false
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
