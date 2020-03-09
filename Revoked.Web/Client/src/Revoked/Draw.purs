module Draw where

import Prelude

import Emo8.Class.Object (position, size)
import Constants (mapSizeInt, mapTileInMonitorSize, mapTileSize, mapSize, hudTextHeight)
import Data.Array ((!!))
import Data.Maybe (Maybe(..))
import Data.Player (Player, playerShotCount, playerGunIsInfinite)
import Emo8.Action.Draw (Draw, drawMap, drawText)
import Emo8.Data.Color (Color(..))
import Emo8.Types (MapId, X, PlayerScore)

-- | Draws the region of the scroll map visible 
drawScrollMap :: X -> MapId -> Draw Unit
drawScrollMap distance mapId = do
    when (-mapSizeInt * mapTileInMonitorSize.width <= distance && distance < mapSize.width) $ drawMap mapId mapTileSize (-distance) 0

-- | Draws the username string 
drawUsername :: (Array String) -> Draw Unit
drawUsername username = do

    -- Draw characters
    drawText char0 textHeight x y color
    drawText char1 textHeight (x + 21) y color
    drawText char2 textHeight (x + 42) y color
    where
        char0 = characterAt 0 
        char1 = characterAt 1 
        char2 = characterAt 2 
        x = 635
        y = 235
        textHeight = 27
        color = White

        -- Retrieve username character or placeholder
        characterAt :: Int -> String
        characterAt index = case username !! index of
            Nothing -> "_"
            Just char -> char

-- | Draws the given player score where it's vertical coordinate is based on its position attribute.
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

-- | Draws the player shot count if the players gun is not infinite ammo
drawPlayerShotCount :: Player -> Draw Unit
drawPlayerShotCount p = 
    if playerGunIsInfinite p 
        then pure unit 
        else drawText (show shotCount) hudTextHeight x y Lime
    where 
        pos = position p
        playerSize = size p
        shotCount = playerShotCount p
        x = pos.x 
        y = pos.y + playerSize.height + 25