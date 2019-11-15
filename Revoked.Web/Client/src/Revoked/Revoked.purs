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
import Data.Goal (Goal, updateGoal)
import Data.Maybe (Maybe(..))
import Data.Particle (Particle, initParticle, updateParticle)
import Data.Player (Player, addBullet, initialPlayer, updatePlayer)
import Effect (Effect)
import Emo8 (emo8)
import Emo8.Action.Draw (cls, drawScaledImage, drawText)
import Emo8.Class.Game (class Game)
import Emo8.Data.Color (Color(..))
import Emo8.FFI.AudioController (AudioController, _addAudioStream, _isAudioStreamPlaying, _stopAudioStream, newAudioController)
import Emo8.Input (isCatchAny, mapToCharacter)
import Emo8.Types (MapId, Score)
import Emo8.Utils (defaultMonitorSize, mkAsset)
import Helper (drawScrollMap, isCollideMapWalls, isCollideMapHazards, adjustMonitorDistance, drawUsername)
import Levels (allRawLevels, enemies, goals, levelCount)

data State = 
    TitleScreen 
    | GameOver
    | Victory {
        username :: Array String,
        score :: Int,
        inputInterval :: Int
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
        audioController :: AudioController
    }

instance gameState :: Game State where
    update input TitleScreen = do
        pure $ if isCatchAny input  then initialPlayState else TitleScreen
    update input GameOver =
        pure $ if isCatchAny input then initialState else GameOver
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
            newInputInterval = if addCharacter || removeCharacter then 10 else if s.inputInterval == 0 then 0 else s.inputInterval - 1

        pure $ case enterPressed, isMaxUsernameLength of
            true, true -> initialState
            _, _ -> Victory $ s {
                username = newUsername,
                inputInterval = newInputInterval
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

        -- update music
        let newAudioController = case isBackgroundMusicPlaying, isGameOver of
                true, true -> _stopAudioStream s.audioController A.backgroundMusicId
                false, false ->  _addAudioStream s.audioController A.backgroundMusicId
                _, _ -> s.audioController

        pure $ case isGameOver, isNextLevel of
            true, _ -> GameOver
            false, true -> if s.mapId + 1 >= levelCount then initialVictoryState s.score else newLevel (s.mapId + 1) s.score s.audioController
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
                audioController = newAudioController
            }

    draw TitleScreen = do
        drawScaledImage I.titleScreen 0 0
    draw GameOver = do
        drawScaledImage I.gameOverScreen 0 0
    draw (Victory s) = do
        drawScaledImage I.blackBackground 0 0
        drawUsername s.username
    draw (Play s) = do
        drawScaledImage I.blackBackground 0 0
        drawScrollMap s.distance s.mapId
        draw s.player
        traverse_ draw s.bullets
        traverse_ draw s.enemies
        traverse_ draw s.particles
        traverse_ draw s.enemyBullets
        traverse_ draw s.goals
        drawText ("Score: " <> show s.score) scoreDisplayTextHeight scoreDisplayX scoreDisplayY

newLevel :: MapId -> Score -> AudioController -> State
newLevel mapId score audioController = Play { 
    distance: 0, 
    player: initialPlayer, 
    bullets: [], 
    enemies: enemies mapId, 
    particles: [], 
    enemyBullets : [],
    goals: goals mapId,
    mapId: mapId,
    score: score,
    audioController: audioController
}

initialPlayState :: State
initialPlayState = newLevel 0 0 $ newAudioController "Play"

initialVictoryState :: Score -> State
initialVictoryState score = Victory {
    username: [],
    score: score,
    inputInterval: 0
} 

initialState :: State
initialState = TitleScreen

main :: Effect Unit
main = do
    asset <- mkAsset allRawLevels
    emo8 initialState asset defaultMonitorSize
