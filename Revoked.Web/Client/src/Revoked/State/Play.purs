module States.Play where

import Prelude

import Assets.Audio as A
import States.StateIds as S
import Class.Object (scroll)
import Collision (isCollideObjects, isOutOfWorld)
import Data.Array (any, filter, partition, concatMap)
import Data.Bullet (Bullet, updateBullet)
import Data.Enemy (Enemy, updateEnemy, enemyToScore)
import Data.Foldable (sum)
import Data.Either (Either(..))
import Data.Goal (Goal, updateGoal, isNextLevelGoal, firstGun)
import Data.Particle (Particle, updateParticle)
import Data.Player (Player, initialPlayer, updatePlayer, updatePlayerGun)
import Emo8.Action.Update (Update, isAudioStreamPlaying, stopAudioStream, addAudioStream, nowDateTime, muteAudio, unmuteAudio)
import Data.DateTime (DateTime)
import Emo8.FFI.AudioController (AudioController, newAudioController)
import Emo8.Input (Input)
import Emo8.Types (MapId, Score, StateId, Asset)
import Levels (enemies, goals, levelCount)
import Helper (isCollideMapWalls, isCollideMapHazards, adjustMonitorDistance, formatDifference, enemyToParticle)

type PlayState = { 
    distance :: Int, 
    player :: Player, 
    bullets :: Array Bullet, 
    enemies :: Array Enemy,
    particles :: Array Particle, 
    enemyBullets :: Array Bullet,
    goals :: Array Goal,
    mapId :: MapId,
    score :: Score,
    audioController :: AudioController,
    start :: DateTime,
    elapsed :: String
}

updatePlay :: Asset -> Input -> PlayState -> Update (Either PlayState StateId)
updatePlay asset input s = do

    -- adjust player, entities and map for scrolling
    let { player: updatedPlayer, bullets: newBullets } = updatePlayer input s.player s.distance (isCollideMapWalls asset s.mapId s.distance)
        newDistance = adjustMonitorDistance updatedPlayer s.distance
        scrollOffset = (s.distance - newDistance)
        scrollAdjustedPlayer = scroll scrollOffset updatedPlayer
        scrollAdjustedBullets = map (scroll scrollOffset) s.bullets
        scrollAdjustedEnemies = map (scroll scrollOffset) s.enemies
        scrollAdjustedGoals = map (scroll scrollOffset) s.goals
        scrollAdjustedParticles = map (scroll scrollOffset) s.particles
        scrollAdjustedEnemyBullets = map (scroll scrollOffset) s.enemyBullets

    -- updated entities
    let { yes: enemiesInView, no: enemiesNotInView } = partition (not <<< isOutOfWorld) scrollAdjustedEnemies
        updatedEnemiesAndNewBullets = map (updateEnemy (isCollideMapWalls asset s.mapId s.distance) s.distance s.player) enemiesInView
        updatedEnemies = map toEnemy updatedEnemiesAndNewBullets
        newEnemyBullets = concatMap toBullets updatedEnemiesAndNewBullets
        updatedGoals = map updateGoal scrollAdjustedGoals
        updatedParticles = map updateParticle scrollAdjustedParticles
        updatedBullets = map updateBullet scrollAdjustedBullets
        updatedEnemyBullets = map updateBullet scrollAdjustedEnemyBullets

    -- player collision
    let hasCollidedHazard = isCollideMapHazards asset s.mapId s.distance scrollAdjustedPlayer
        hasCollidedEnemy = any (isCollideObjects scrollAdjustedPlayer) updatedEnemies
        hasCollidedEnemyBullet = any (isCollideObjects scrollAdjustedPlayer) updatedEnemyBullets

    -- collision with enemies
    let { yes: collidedEnemies, no: notCollidedEnemies } = partition (\e -> any (isCollideObjects e) updatedBullets) updatedEnemies
        { yes: collidedBullets, no: notCollidedBullets } = partition (\b -> any (isCollideObjects b) updatedEnemies) updatedBullets
        { yes: collidedGoals, no: notCollidedGoals } = partition (isCollideObjects scrollAdjustedPlayer) updatedGoals

    -- add new entities
    let newParticles = map enemyToParticle collidedEnemies
        newScore = sum $ map enemyToScore collidedEnemies

    -- delete entities (out of monitor)
    let updatedBulletsInView = filter (not <<< isOutOfWorld) notCollidedBullets
        updatedEnemyBulletsInView = filter (not <<< isOutOfWorld) updatedEnemyBullets
        updatedParticlesInView = filter (not <<< isOutOfWorld) updatedParticles

    -- delete entities (map collision)
    let notCollidedWithMapBullets = filter (not <<< (isCollideMapWalls asset s.mapId s.distance)) updatedBulletsInView
        notCollidedWithMapEnemyBullets = filter (not <<< (isCollideMapWalls asset s.mapId s.distance)) updatedEnemyBulletsInView

    -- evaluate game condition
    let isGameOver = hasCollidedHazard || hasCollidedEnemy || hasCollidedEnemyBullet
        isNextLevel = any isNextLevelGoal collidedGoals
        isLastLevel = s.mapId + 1 >= levelCount

    -- update gun based on ammo 
    let newPlayer = updatePlayerGun (firstGun collidedGoals) scrollAdjustedPlayer 

    -- update music
    isBackgroundMusicPlaying <- isAudioStreamPlaying s.audioController A.backgroundMusicId
    newAudioController <- updateAudioController s.audioController input (isGameOver || (isNextLevel && isLastLevel))
    
    now <- nowDateTime
    
    pure $ case isGameOver, isNextLevel of
        true, _ -> Right S.gameOverId
        false, true -> if isLastLevel 
            then Right $ S.victoryId
            else Left $ newLevel (s.mapId + 1) s.score s.audioController s.elapsed s.start
        false, false -> Left $ s { 
            distance = newDistance, 
            player = newPlayer, 
            bullets = notCollidedWithMapBullets <> newBullets, 
            enemies = notCollidedEnemies <> enemiesNotInView, 
            particles = updatedParticlesInView <> newParticles, 
            enemyBullets = notCollidedWithMapEnemyBullets <> newEnemyBullets,
            goals = notCollidedGoals,
            mapId = s.mapId,
            score = s.score + newScore,
            audioController = newAudioController,
            start = s.start,
            elapsed = formatDifference s.start now
        }

newLevel :: MapId -> Score -> AudioController -> String -> DateTime -> PlayState
newLevel mapId score audioController elapsed start = { 
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
    start: start,
    elapsed: elapsed
}

initialPlayState :: DateTime -> PlayState
initialPlayState = newLevel 0 0 (newAudioController "Play") "0:00"

toBullets :: { enemy :: Enemy, bullets :: Array Bullet } -> Array Bullet
toBullets enemyAndBullets = enemyAndBullets.bullets

toEnemy :: { enemy :: Enemy, bullets :: Array Bullet } -> Enemy
toEnemy enemyAndBullets = enemyAndBullets.enemy

updateAudioController :: AudioController -> Input -> Boolean -> Update AudioController
updateAudioController controller input shouldStop = do

    isBackgroundMusicPlaying <- isAudioStreamPlaying controller A.backgroundMusicId

    controllerWithBackgroundMusic <- case isBackgroundMusicPlaying, shouldStop of
            true, true -> stopAudioStream controller A.backgroundMusicId
            false, false -> addAudioStream controller A.backgroundMusicId
            _, _ -> pure controller

    updatedController <- if input.released.isM 
        then if controllerWithBackgroundMusic.muted 
            then unmuteAudio controllerWithBackgroundMusic 
            else muteAudio controllerWithBackgroundMusic
        else pure controllerWithBackgroundMusic

    pure updatedController