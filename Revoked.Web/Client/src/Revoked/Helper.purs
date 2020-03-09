module Helper where

import Prelude

import Emo8.Class.Object (position)
import Constants (leftBoundry, mapSize, rightBoundry)
import Data.DateTime (DateTime, diff)
import Data.Either (Either(..))
import Data.Enemy (Enemy(..))
import Data.Formatter.DateTime as F
import Data.Int (floor)
import Data.Particle (Particle, defaultGhostParticle, defaultExplosionParticle)
import Data.Player (Player(..))
import Data.Time.Duration (Milliseconds(..))
import Emo8.Constants (defaultMonitorSize)
import Emo8.Types (X)

-- | Adjusts the monitor distance so that player remains between the left and right 
-- | boundry on the screen.
adjustMonitorDistance :: Player -> X -> X
adjustMonitorDistance (Player player) distance = 
    case isLevelAtMinimumDistance, isLevelAtMaximumDistance, isInLeftBoundry, isInRightBoundry of
        true, _, true, _ -> 0
        _, true, _, true -> mapSize.width
        false, _, true, _ -> if newDistanceIfInLeftBoundry < 0 then 0 else newDistanceIfInLeftBoundry
        _, false, _, true -> if newDistanceIfInRightBoundry > mapSize.width - defaultMonitorSize.width then mapSize.width - defaultMonitorSize.width else newDistanceIfInRightBoundry   
        _, _, _, _ -> distance
    where
        playerPos = player.pos
        playerWidth = player.sprite.size.width
        newDistanceIfInLeftBoundry = distance + playerPos.x - leftBoundry
        newDistanceIfInRightBoundry = distance + playerPos.x + playerWidth - rightBoundry
        isLevelAtMinimumDistance = distance == 0
        isLevelAtMaximumDistance = distance == mapSize.width
        isInLeftBoundry = playerPos.x < leftBoundry
        isInRightBoundry = playerPos.x + playerWidth > rightBoundry

-- | Format a DateTime into a string that can be parsed by the server
formatDateTime :: DateTime -> String
formatDateTime dt = case F.formatDateTime "YYYY/MM/DD hh:mm:ss" dt of
    Left error -> ""
    Right dateString -> dateString

-- | Format the difference between two DateTimes into the minutes and seconds duration
formatDifference :: DateTime -> DateTime -> String
formatDifference start end = show minutes <> ":" <> show seconds
    where
        (Milliseconds milliseconds) = diff end start
        totalSeconds = floor $ milliseconds / 1000.0
        minutes = totalSeconds / 60
        seconds = mod totalSeconds 60

-- | Converts a Enemy into a Particle
enemyToParticle :: Enemy -> Particle
enemyToParticle (EnemyMarine m) = defaultGhostParticle m.pos
enemyToParticle (EnemyDrone m) = defaultExplosionParticle m.pos
enemyToParticle (EnemyBigBertha m) = defaultExplosionParticle $ position m.phase
