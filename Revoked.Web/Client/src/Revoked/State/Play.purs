module States.Play where

import Prelude

import Assets.Audio as A
import States.StateIds as S
import Class.Object (position, scroll)
import Collision (isCollideObjects, isOutOfWorld)
import Data.Array (any, filter, partition)
import Data.Bullet (Bullet, updateBullet)
import Data.Enemy (Enemy, addEnemyBullet, updateEnemy, enemyToScore)
import Data.EnemyBullet (EnemyBullet, updateEnemyBullet)
import Data.Foldable (sum)
import Data.Either (Either(..))
import Data.Goal (Goal, updateGoal)
import Data.Particle (Particle, initParticle, updateParticle)
import Data.Player (Player, addBullet, initialPlayer, updatePlayer)
import Emo8.Action.Update (Update, nowDateTime, isAudioStreamPlaying, stopAudioStream, addAudioStream)
import Data.DateTime (DateTime)
import Emo8.FFI.AudioController (AudioController, newAudioController)
import Emo8.Input (Input)
import Emo8.Types (MapId, Score, StateId, Asset)
import Levels (enemies, goals, levelCount)
import Helper (isCollideMapWalls, isCollideMapHazards, adjustMonitorDistance)

type PlayState = { 
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

updatePlay :: Asset -> Input -> PlayState -> Update (Either PlayState StateId)
updatePlay asset input s = do

    -- adjust player, entities and map for scrolling
    let updatedPlayer = updatePlayer input s.player s.distance (isCollideMapWalls asset s.mapId s.distance)
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
        updatedBullets = map updateBullet scrollAdjustedBullets
        updatedEnemies = map (updateEnemy (isCollideMapWalls asset s.mapId s.distance) s.distance s.player) enemiesInView
        updatedGoals = map updateGoal scrollAdjustedGoals
        updatedParticles = map updateParticle scrollAdjustedParticles
        updatedEnemyBullets = map updateEnemyBullet scrollAdjustedEnemyBullets

    -- player collision
    let hasCollidedHazard = isCollideMapHazards asset s.mapId s.distance scrollAdjustedPlayer
        hasCollidedEnemy = any (isCollideObjects scrollAdjustedPlayer) updatedEnemies
        hasCollidedEnemyBullet = any (isCollideObjects scrollAdjustedPlayer) updatedEnemyBullets
        hasCollidedGoal = any (isCollideObjects scrollAdjustedPlayer) s.goals

    -- collision with enemies
    let { yes: collidedEnemies, no: notCollidedEnemies } = partition (\e -> any (isCollideObjects e) updatedBullets) updatedEnemies
        { yes: collidedBullets, no: notCollidedBullets } = partition (\b -> any (isCollideObjects b) updatedEnemies) updatedBullets

    -- add new entities
    let newBullets = addBullet input s.player
        newParticles = map (\e -> initParticle (position e)) collidedEnemies
        newEnemyBullets = notCollidedEnemies >>= addEnemyBullet s.player
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
        isNextLevel = hasCollidedGoal
        isLastLevel = s.mapId + 1 >= levelCount

    isBackgroundMusicPlaying <- isAudioStreamPlaying s.audioController A.backgroundMusicId

    -- update music
    newAudioController <- case isBackgroundMusicPlaying, (isGameOver || (isNextLevel && isLastLevel)) of
            true, true -> stopAudioStream s.audioController A.backgroundMusicId
            false, false ->  addAudioStream s.audioController A.backgroundMusicId
            _, _ -> pure s.audioController
    
    pure $ case isGameOver, isNextLevel of
        true, _ -> Right S.gameOverId
        false, true -> if isLastLevel 
            then Right $ S.victoryId
            else Left $ newLevel (s.mapId + 1) s.score s.audioController s.start
        false, false -> Left $ s { 
            distance = newDistance, 
            player = scrollAdjustedPlayer, 
            bullets = notCollidedWithMapBullets <> newBullets, 
            enemies = notCollidedEnemies <> enemiesNotInView, 
            particles = updatedParticlesInView <> newParticles, 
            enemyBullets = notCollidedWithMapEnemyBullets <> newEnemyBullets,
            goals = updatedGoals,
            mapId = s.mapId,
            score = s.score + newScore,
            audioController = newAudioController,
            start = s.start
        }

newLevel :: MapId -> Score -> AudioController -> DateTime -> PlayState
newLevel mapId score audioController start = { 
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

initialPlayState :: DateTime -> PlayState
initialPlayState = newLevel 0 0 $ newAudioController "Play"
