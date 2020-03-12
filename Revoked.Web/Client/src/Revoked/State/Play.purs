module Revoked.States.Play where

import Prelude

import Data.Array (any, filter, partition, concatMap, length)
import Data.Foldable (sum)
import Data.Either (Either(..))
import Data.DateTime (DateTime)

import Emo8.Class.Object (scroll)
import Emo8.Collision (isCollideObjects, isOutOfWorld)
import Emo8.Action.Update (Update, isAudioStreamPlaying, stopAudioStream, addAudioStream, nowDateTime, muteAudio, unmuteAudio)
import Emo8.FFI.AudioController (AudioContext, newAudioContext)
import Emo8.Input (Input)
import Emo8.Types (MapId, Score, StateId, Asset)

import Revoked.Assets.Audio as A
import Revoked.States.StateIds as S
import Revoked.Class.MortalEntity (damage, heal)
import Revoked.Collision (isCollideMapWalls, isCollideMapHazards)
import Revoked.Data.Bullet (Bullet, updateBullet)
import Revoked.Data.Enemy (Enemy, updateEnemy, enemyToScore)
import Revoked.Data.Goal (Goal, updateGoal, isNextLevelGoal, firstGun, toHealthBonus)
import Revoked.Data.Particle (Particle, updateParticle)
import Revoked.Data.Player (Player(..), initialPlayer, updatePlayer, updatePlayerGun)
import Revoked.Data.Helper (isDead)
import Revoked.Levels (enemies, goals, levelCount, startPosition)
import Revoked.Helper (adjustMonitorDistance, formatDifference, enemyToParticle)

-- | Represents the play state
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
    audioContext :: AudioContext,
    start :: DateTime,
    elapsed :: String
}

-- | Update the given `PlayState` based on the user input.
updatePlay :: Asset -> Input -> PlayState -> Update (Either PlayState StateId)
updatePlay asset input s = do

    -- Adjust player, entities and map for scrolling
    let { player: updatedPlayer, bullets: newBullets } = updatePlayer input s.player s.distance (isCollideMapWalls asset s.mapId s.distance)
        newDistance = adjustMonitorDistance updatedPlayer s.distance
        scrollOffset = (s.distance - newDistance)
        scrollAdjustedPlayer = scroll scrollOffset updatedPlayer
        scrollAdjustedBullets = map (scroll scrollOffset) s.bullets
        scrollAdjustedEnemies = map (scroll scrollOffset) s.enemies
        scrollAdjustedGoals = map (scroll scrollOffset) s.goals
        scrollAdjustedParticles = map (scroll scrollOffset) s.particles
        scrollAdjustedEnemyBullets = map (scroll scrollOffset) s.enemyBullets

    -- Updated entities
    let { yes: enemiesInView, no: enemiesNotInView } = partition (not <<< isOutOfWorld) scrollAdjustedEnemies
        updatedEnemiesAndNewBullets = map (updateEnemy (isCollideMapWalls asset s.mapId s.distance) s.distance s.player) enemiesInView
        updatedEnemies = map toEnemy updatedEnemiesAndNewBullets
        newEnemyBullets = concatMap toBullets updatedEnemiesAndNewBullets
        updatedGoals = map updateGoal scrollAdjustedGoals
        updatedParticles = map updateParticle scrollAdjustedParticles
        updatedBullets = map updateBullet scrollAdjustedBullets
        updatedEnemyBullets = map updateBullet scrollAdjustedEnemyBullets

    -- Player collision
    let hasCollidedHazard = isCollideMapHazards asset s.mapId s.distance scrollAdjustedPlayer
        hasCollidedEnemy = any (isCollideObjects scrollAdjustedPlayer) updatedEnemies

    -- Collision with enemies
    let { yes: collidedEnemies, no: notCollidedEnemies } = partition (\e -> any (isCollideObjects e) updatedBullets) updatedEnemies
        { yes: collidedBullets, no: notCollidedBullets } = partition (\b -> any (isCollideObjects b) updatedEnemies) updatedBullets
        { yes: collidedEnemyBullets, no: notCollidedEnemyBullets } = partition (isCollideObjects scrollAdjustedPlayer) updatedEnemyBullets
        { yes: collidedGoals, no: notCollidedGoals } = partition (isCollideObjects scrollAdjustedPlayer) updatedGoals

        -- Apply damage to enemies and map the dead enemies into particles
        damageCounter = (\e -> length (filter (isCollideObjects e) updatedBullets))
        damagedEnemies = map (\e -> damage e (damageCounter e)) collidedEnemies 
        { yes: deadEnemies, no: damagedButAliveEnemies } = partition isDead damagedEnemies
        newParticles = map enemyToParticle deadEnemies
        
    -- Calculate the score to add
    let newScore = sum $ map enemyToScore deadEnemies

    -- Delete entities (out of monitor)
    let updatedBulletsInView = filter (not <<< isOutOfWorld) notCollidedBullets
        updatedEnemyBulletsInView = filter (not <<< isOutOfWorld) notCollidedEnemyBullets
        updatedParticlesInView = filter (not <<< isOutOfWorld) updatedParticles

    -- Delete entities (map collision)
    let notCollidedWithMapBullets = filter (not <<< (isCollideMapWalls asset s.mapId s.distance)) updatedBulletsInView
        notCollidedWithMapEnemyBullets = filter (not <<< (isCollideMapWalls asset s.mapId s.distance)) updatedEnemyBulletsInView

    -- Apply damage and health bonuses
    let collidedEnemyBulletCount = length collidedEnemyBullets
        damagedPlayer = damage scrollAdjustedPlayer collidedEnemyBulletCount
        healthBonusedPlayer = heal damagedPlayer (toHealthBonus collidedGoals)
        newPlayer = updatePlayerGun (firstGun collidedGoals) healthBonusedPlayer 

    -- Evaluate game condition
    let isPlayerDead = isDead newPlayer
        isGameOver = hasCollidedHazard || hasCollidedEnemy || isPlayerDead
        isNextLevel = any isNextLevelGoal collidedGoals
        isLastLevel = s.mapId + 1 >= levelCount

    -- Update music
    newAudioContext <- updateAudioContext s.audioContext input (isGameOver || (isNextLevel && isLastLevel))
    
    -- Get the current date time
    now <- nowDateTime
    
    pure $ case isGameOver, isNextLevel of
        true, _ -> Right S.gameOverId -- To Game over
        false, true -> if isLastLevel 
            then Right $ S.victoryId -- To victory
            else Left $ newLevel s.player s.score s.audioContext s.elapsed (s.mapId + 1) s.start -- To next Level
        false, false -> Left $ s { 
            distance = newDistance, 
            player = newPlayer, 
            bullets = notCollidedWithMapBullets <> newBullets, 
            enemies = notCollidedEnemies <> enemiesNotInView <> damagedButAliveEnemies, 
            particles = updatedParticlesInView <> newParticles, 
            enemyBullets = notCollidedWithMapEnemyBullets <> newEnemyBullets,
            goals = notCollidedGoals,
            mapId = s.mapId,
            score = s.score + newScore,
            audioContext = newAudioContext,
            start = s.start,
            elapsed = formatDifference s.start now
        }

-- | Builds a new level with a specifed `MapId`, `Player`, `Score`, `AudioContext`, elapsed time string and 
-- | start `DateTime`.
newLevel :: Player -> Score -> AudioContext -> String -> MapId -> DateTime -> PlayState
newLevel (Player p) score audioContext elapsed mapId start = { 
    distance: 0, 
    player: Player $ p { pos = startPosition mapId }, 
    bullets: [], 
    enemies: enemies mapId, 
    particles: [], 
    enemyBullets : [],
    goals: goals mapId,
    mapId: mapId,
    score: score,
    audioContext: audioContext,
    start: start,
    elapsed: elapsed
}

-- | Builds the initial play state base 
initialPlayState :: MapId -> DateTime -> PlayState
initialPlayState = newLevel (initialPlayer (startPosition 0)) 0 (newAudioContext "Play") "0:00"

-- | Retrieves the `Bullet`s from the enemy and bullets pair
toBullets :: { enemy :: Enemy, bullets :: Array Bullet } -> Array Bullet
toBullets enemyAndBullets = enemyAndBullets.bullets

-- | Retrieves the `Enemy` from the enemy and bullets pair
toEnemy :: { enemy :: Enemy, bullets :: Array Bullet } -> Enemy
toEnemy enemyAndBullets = enemyAndBullets.enemy

-- | Updates the specified `AudioContext` based on the users input and whether the background 
-- | music should stop playing.
updateAudioContext :: AudioContext -> Input -> Boolean -> Update AudioContext
updateAudioContext context input shouldStop = do

    -- Determine if the background music is playing already
    isBackgroundMusicPlaying <- isAudioStreamPlaying context A.backgroundMusic

    -- Start or Stop the background music based on whether its playing and whether the background 
    -- music should stop playing.
    contextWithBackgroundMusic <- case isBackgroundMusicPlaying, shouldStop of
            true, true -> stopAudioStream context A.backgroundMusic
            false, false -> addAudioStream context A.backgroundMusic
            _, _ -> pure context

    -- Mute or Unmute the audio context based on the user input.
    updatedContext <- if input.released.isM 
        then if contextWithBackgroundMusic.muted 
            then unmuteAudio contextWithBackgroundMusic 
            else muteAudio contextWithBackgroundMusic
        else pure contextWithBackgroundMusic

    pure updatedContext