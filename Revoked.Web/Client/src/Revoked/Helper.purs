module Helper where

import Prelude

import Assets.Images as I
import Class.Object (class Object, position, size)
import Collision (isWallsCollide, isHazardCollide)
import Constants (leftBoundry, mapSizeInt, mapTileInMonitorSize, mapTileSize, mapSize, rightBoundry, hudTextHeight)
import Data.Array ((!!), (..))
import Data.DateTime (DateTime, diff)
import Data.Either (Either(..))
import Data.Enemy (Enemy(..))
import Data.Formatter.DateTime as F
import Data.Int (floor)
import Data.Maybe (Maybe(..))
import Data.Particle (Particle, defaultMarineGhostParticle)
import Data.Player (Player(..), playerShotCount, playerGunIsInfinite, playerHealth)
import Data.Time.Duration (Milliseconds(..))
import Data.Traversable (for_)
import Emo8.Action.Draw (Draw, drawMap, drawText, drawScaledImage)
import Emo8.Data.Color (Color(..))
import Emo8.Types (MapId, X, Size, Position, PlayerScore, Asset)
import Emo8.Utils (defaultMonitorSize)

-- TODO: readable
drawScrollMap :: X -> MapId -> Draw Unit
drawScrollMap distance mapId = do
    drawCond mapId distance
    where
        drawCond :: MapId -> X -> Draw Unit
        drawCond mId d = do
            when (-mapSizeInt * mapTileInMonitorSize.width <= d && d < mapSize.width) $
                drawMap mId mapTileSize (-d) 0

isCollideMapWalls :: forall a. Object a => Asset -> MapId -> X -> a -> Boolean
isCollideMapWalls asset mapId distance o = isCollide (isWallsCollide asset) mapId distance o

isCollideMapHazards :: forall a. Object a => Asset -> MapId -> X -> a -> Boolean
isCollideMapHazards asset mapId distance o = isCollide (isHazardCollide asset) mapId distance o

isCollide :: forall a. Object a => (MapId -> Size -> Size -> Position -> Boolean) -> MapId -> X -> a -> Boolean
isCollide f mapId distance o =
    collCond mapId distance
    where
        collCond :: MapId -> X -> Boolean
        collCond mId d = do
            if (-mapSizeInt * mapTileInMonitorSize.width <= d && d < mapSize.width)
                then f mId mapTileSize (size o) { x: (position o).x + d, y: (position o).y }
                else false

adjustMonitorDistance :: Player -> X -> X
adjustMonitorDistance (Player player) distance = 
    case isLevelAtMinimumDistance distance, isLevelAtMaximumDistance distance, isInLeftBoundry playerPos, isInRightBoundry playerPos of
        true, _, true, _ -> 0
        _, true, _, true -> mapSize.width
        false, _, true, _ -> if(newDistanceIfInLeftBoundry < 0) then 0 else newDistanceIfInLeftBoundry
        _, false, _, true -> if(newDistanceIfInRightBoundry > mapSize.width - defaultMonitorSize.width) then mapSize.width - defaultMonitorSize.width else newDistanceIfInRightBoundry   
        _, _, _, _ -> distance
    where
        playerPos = player.pos
        playerWidth = player.sprite.size.width
        newDistanceIfInLeftBoundry = distance + playerPos.x - leftBoundry
        newDistanceIfInRightBoundry = distance + playerPos.x + playerWidth - rightBoundry

        isLevelAtMinimumDistance :: X -> Boolean
        isLevelAtMinimumDistance d = d == 0

        isLevelAtMaximumDistance :: X -> Boolean
        isLevelAtMaximumDistance d = d == mapSize.width

        isInLeftBoundry :: Position -> Boolean
        isInLeftBoundry p = p.x < leftBoundry

        isInRightBoundry :: Position -> Boolean
        isInRightBoundry p = p.x + playerWidth > rightBoundry

formatDateTime :: DateTime -> String
formatDateTime dt = case F.formatDateTime "YYYY/MM/DD hh:mm:ss" dt of
    Left error -> ""
    Right dateString -> dateString

formatDifference :: DateTime -> DateTime -> String
formatDifference start end = show minutes <> ":" <> show seconds
    where
        (Milliseconds milliseconds) = diff end start
        totalSeconds = floor $ milliseconds / 1000.0
        minutes = totalSeconds / 60
        seconds = mod totalSeconds 60

drawUsername :: (Array String) -> Draw Unit
drawUsername username = do
    drawText char0 textHeight x y color
    drawText char1 textHeight (x + 21) y color
    drawText char2 textHeight (x + 42) y color
    where
        char0 = character username 0 
        char1 = character username 1 
        char2 = character username 2 
        x = 635
        y = 235
        textHeight = 27
        color = White

        character :: (Array String) -> Int -> String
        character u index = case u !! index of
            Nothing -> "_"
            Just char -> char

drawScore :: PlayerScore -> Draw Unit
drawScore ps = do 
    drawText ps.username textHeight usernameX y color
    drawText (show ps.score) textHeight scoreX y color
    drawText ps.time textHeight timeX y color
    drawText (show ps.position) textHeight positionX y color
    where 
        textHeight = 27
        positionX = 420
        usernameX = 500
        scoreX = 600
        timeX = 700 
        startY = 500
        paddingY = 15
        color = White
        y = startY - ((ps.position - 1) * (textHeight + paddingY))

enemyToParticle :: Enemy -> Particle
enemyToParticle (EnemyMarine m) = defaultMarineGhostParticle m.pos

drawPlayerShotCount :: Player -> Draw Unit
drawPlayerShotCount p = do
    drawText (if playerGunIsInfinite p then "" else show shotCount) hudTextHeight x y Lime
        where 
            pos = position p
            playerSize = size p
            shotCount = playerShotCount p
            x = pos.x 
            y = pos.y + playerSize.height + 25

drawHealth :: Player -> Draw Unit
drawHealth p = do
    for_ (map toHeartPosition indexes) \(heartPos) -> 
        drawScaledImage I.heart heartPos.x heartPos.y
        where 
            pos = position p
            playerSize = size p
            health = playerHealth p
            indexes = if health > 0 then 0 .. (health - 1) else []
            padding = 5
            increment = I.heart.size.width + padding
            width = increment * health
            toHeartPosition :: Int -> Position
            toHeartPosition i = { 
                x: pos.x - ( width / 2) + (i * increment) + (playerSize.width / 2), 
                y: pos.y + playerSize.height + 5
            }