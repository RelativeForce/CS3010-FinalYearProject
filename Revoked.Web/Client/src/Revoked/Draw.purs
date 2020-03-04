module Draw where

import Prelude

import Class.Object (position, size)
import Constants (mapSizeInt, mapTileInMonitorSize, mapTileSize, mapSize, hudTextHeight)
import Data.Array ((!!))
import Data.Maybe (Maybe(..))
import Data.Player (Player, playerShotCount, playerGunIsInfinite)
import Emo8.Action.Draw (Draw, drawMap, drawText)
import Emo8.Data.Color (Color(..))
import Emo8.Types (MapId, X, PlayerScore)


drawScrollMap :: X -> MapId -> Draw Unit
drawScrollMap distance mapId = do
    drawCond mapId distance
    where
        drawCond :: MapId -> X -> Draw Unit
        drawCond mId d = do
            when (-mapSizeInt * mapTileInMonitorSize.width <= d && d < mapSize.width) $
                drawMap mId mapTileSize (-d) 0

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

drawPlayerShotCount :: Player -> Draw Unit
drawPlayerShotCount p = do
    drawText (if playerGunIsInfinite p then "" else show shotCount) hudTextHeight x y Lime
        where 
            pos = position p
            playerSize = size p
            shotCount = playerShotCount p
            x = pos.x 
            y = pos.y + playerSize.height + 25