module Helper where

import Prelude

import Class.Object (class Object, position, size)
import Collision (isWallsCollide, isHazardCollide)
import Constants (leftBoundry, mapSizeInt, mapTileInMonitorSize, mapTileSize, mapSize, rightBoundry)
import Emo8.Utils (defaultMonitorSize)
import Data.Player (Player(..))
import Data.Array ((!!))
import Data.Maybe (Maybe(..))
import Data.Either (Either(..))
import Emo8.Action.Draw (Draw, drawMap, drawText)
import Data.HighScores (PlayerScore)
import Emo8.Data.Color (Color(..))
import Emo8.Action.Update (Update)
import Emo8.Types (MapId, X, Size, Position)
import Data.Formatter.DateTime as F
import Data.DateTime (DateTime)

-- TODO: readable
drawScrollMap :: X -> MapId -> Draw Unit
drawScrollMap distance mapId = do
    drawCond mapId distance
    where
        drawCond :: MapId -> X -> Draw Unit
        drawCond mId d = do
            when (-mapSizeInt * mapTileInMonitorSize.width <= d && d < mapSize.width) $
                drawMap mId mapTileSize (-d) 0

-- TODO: readable
isCollideMapWalls :: forall a. Object a => MapId -> X -> a -> Update Boolean
isCollideMapWalls mapId distance o = isCollide (isWallsCollide) mapId distance o

isCollideMapHazards :: forall a. Object a => MapId -> X -> a -> Update Boolean
isCollideMapHazards mapId distance o = isCollide (isHazardCollide) mapId distance o

isCollide :: forall a. Object a => (MapId -> Size -> Size -> Position -> Update Boolean) -> MapId -> X -> a -> Update Boolean
isCollide f mapId distance o =
    collCond mapId distance
    where
        collCond :: MapId -> X -> Update Boolean
        collCond mId d = do
            if (-mapSizeInt * mapTileInMonitorSize.width <= d && d < mapSize.width)
                then f mId mapTileSize (size o) { x: (position o).x + d, y: (position o).y }
                else pure false

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

drawUsername :: (Array String) -> Draw Unit
drawUsername username = do
    drawText char0 textHeight x y color
    drawText char1 textHeight (x + 21) y color
    drawText char2 textHeight (x + 46) y color
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

drawLeaderboard :: Array PlayerScore -> Draw Unit
drawLeaderboard scores = do
    drawScore scores 0
    drawScore scores 1
    drawScore scores 2
    drawScore scores 3
    drawScore scores 4
    drawScore scores 5
    drawScore scores 6
    drawScore scores 7
    drawScore scores 8
    drawScore scores 9
    where 
        textHeight = 27
        usernameX = 300
        scoreX = 350
        timeX = 400 
        startY = 500
        paddingY = 15
        color = White
        drawScore :: Array PlayerScore -> Int -> Draw Unit
        drawScore s index = do 
            let 
                playerScoreAtIndex = s !! index
                username = case playerScoreAtIndex of
                    Nothing -> ""
                    Just ps -> ps.username
                score = case playerScoreAtIndex of
                    Nothing -> ""
                    Just ps -> show ps.score
                time = case playerScoreAtIndex of
                    Nothing -> ""
                    Just ps -> ps.time
                y = startY - (index * (textHeight + paddingY))
            
            drawText username textHeight usernameX y color
            drawText score textHeight scoreX y color
            drawText time textHeight timeX y color
