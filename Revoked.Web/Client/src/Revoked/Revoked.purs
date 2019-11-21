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
import Emo8.Action.Update (nowDateTime, listTopScores, storePlayerScore)
import Emo8.Class.Game (class Game)
import Emo8.Data.Color (Color(..))
import Data.DateTime (DateTime)
import Emo8.FFI.AudioController (AudioController, _addAudioStream, _isAudioStreamPlaying, _stopAudioStream, newAudioController)
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
    | Play { 
        distance :: Int, 
        player :: Player, 
        bullets :: Array Bullet, 
        enemies :: Array Enemy,
        particles :: Array Particle, 
        enemyBullets :: Array EnemyBullet,
        goals :: Array Goal,
        mapId :: MapId,
        score :: Score,
        audioController :: AudioController,
        start :: DateTime
    }

instance gameState :: Game State where
    update input TitleScreen = do
        startDateTime <- nowDateTime

        let
            toLeaderboard = input.catched.isL
            toPlay = isCatchAny input

        pure $ case toPlay, toLeaderboard of 
            false, true -> initialLeaderboardState
            true, false -> initialPlayState startDateTime
            _, _ -> TitleScreen
    update input GameOver =
        pure $ if isCatchAny input then TitleScreen else GameOver
    update input (Leaderboard s) = do
        let 
            hasNoScores = 0 == length s.scores
            shouldLoadScores = not s.isLoaded && (s.isWaiting || hasNoScores)  

        result <- if shouldLoadScores
            then do listTopScores
            else pure $ Left "AllowInput"

        let
            isWaiting = case result of
                Left "Waiting" -> true
                _-> false
            isLoaded = case result of
                Right response -> true
                _-> false
            scores = case result of
                Right response -> response
                _-> s.scores

            backToTitleScreen = input.catched.isBackspace
            
        pure $ case backToTitleScreen of
            true -> TitleScreen
            false -> Leaderboard $ s {
                scores = scores,
                isWaiting = isWaiting,
                isLoaded = isLoaded
            }
    update input (Victory s) = do
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
    update input (Play s) = do

        -- update player
        updatedPlayer <- updatePlayer input s.player s.distance (isCollideMapWalls s.mapId s.distance)

        -- adjust entities and map for scrolling
        let newDistance = adjustMonitorDistance updatedPlayer s.distance
            scrollOffset = (s.distance - newDistance)
            scrollAdjustedPlayer = scroll scrollOffset updatedPlayer
            scrollAdjustedBullets = map (scroll scrollOffset) s.bullets
            scrollAdjustedEnemies = map (scroll scrollOffset) s.enemies
            scrollAdjustedGoals = map (scroll scrollOffset) s.goals
            scrollAdjustedParticles = map (scroll scrollOffset) s.particles
            scrollAdjustedEnemyBullets = map (scroll scrollOffset) s.enemyBullets

        let { yes: enemiesInView, no: enemiesNotInView } = partition (not <<< isOutOfWorld) scrollAdjustedEnemies

        -- updated entities
        let updatedBullets = map updateBullet scrollAdjustedBullets
            updatedEnemies = map (updateEnemy s.player) enemiesInView
            updatedGoals = map updateGoal scrollAdjustedGoals
            updatedParticles = map updateParticle scrollAdjustedParticles
            updatedEnemyBullets = map updateEnemyBullet scrollAdjustedEnemyBullets

        -- player collision
        hasCollidedHazard <- isCollideMapHazards s.mapId s.distance scrollAdjustedPlayer

        let hasCollidedEnemy = any (isCollideObjects scrollAdjustedPlayer) updatedEnemies
            hasCollidedEnemyBullet = any (isCollideObjects scrollAdjustedPlayer) updatedEnemyBullets
            hasCollidedGoal = any (isCollideObjects scrollAdjustedPlayer) s.goals

        -- separate entities
        let 
            { yes: collidedEnemies, no: notCollidedEnemies } = partition (\e -> any (isCollideObjects e) updatedBullets) updatedEnemies
            { yes: collidedBullets, no: notCollidedBullets } = partition (\b -> any (isCollideObjects b) updatedEnemies) updatedBullets

        -- add new entities
        let newBullets = addBullet input s.player
            newParticles = map (\e -> initParticle (position e)) collidedEnemies
            newEnemyBullets = notCollidedEnemies >>= addEnemyBullet s.player
            newScore = sum $ map enemyToScore collidedEnemies

        -- delete entities (out of monitor)
        let updatedBulletsInView = filter (not <<< isOutOfWorld) notCollidedBullets
            updatedParticlesInView = filter (not <<< isOutOfWorld) updatedParticles
            updatedEnemyBulletsInView = filter (not <<< isOutOfWorld) updatedEnemyBullets

        -- evaluate game condition
        let isGameOver = hasCollidedHazard || hasCollidedEnemy || hasCollidedEnemyBullet
            isNextLevel = hasCollidedGoal
            isBackgroundMusicPlaying = _isAudioStreamPlaying s.audioController A.backgroundMusicId
            isLastLevel = s.mapId + 1 >= levelCount

        -- update music
        let newAudioController = case isBackgroundMusicPlaying, (isGameOver || (isNextLevel && isLastLevel)) of
                true, true -> _stopAudioStream s.audioController A.backgroundMusicId
                false, false ->  _addAudioStream s.audioController A.backgroundMusicId
                _, _ -> s.audioController

        now <- nowDateTime

        pure $ case isGameOver, isNextLevel of
            true, _ -> GameOver
            false, true -> if isLastLevel 
                then initialVictoryState s.score s.start now 
                else newLevel (s.mapId + 1) s.score s.audioController s.start
            false, false -> Play $ s { 
                distance = newDistance, 
                player = scrollAdjustedPlayer, 
                bullets = updatedBulletsInView <> newBullets, 
                enemies = notCollidedEnemies <> enemiesNotInView, 
                particles = updatedParticlesInView <> newParticles, 
                enemyBullets = updatedEnemyBulletsInView <> newEnemyBullets,
                goals = updatedGoals,
                mapId = s.mapId,
                score = s.score + newScore,
                audioController = newAudioController,
                start = s.start
            }

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

initialPlayState :: DateTime -> State
initialPlayState = newLevel 0 0 $ newAudioController "Play"

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
