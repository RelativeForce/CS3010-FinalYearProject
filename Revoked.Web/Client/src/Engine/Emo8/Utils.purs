module Emo8.Utils ( 
    mkAsset, 
    emptyAsset, 
    defaultMonitorSize, 
    isMonitorCollide, 
    isOutOfMonitor, 
    isCollide,
    updatePosition
) where

import Prelude

import Data.Traversable (traverse)
import Effect (Effect)
import Emo8.Excepiton (orErrMsg)
import Emo8.Parse (RawMap, parseTileMap)
import Data.Int (toNumber, floor)
import Assets.AssetMapper (emojiToImage)
import Emo8.Types (Asset, MonitorSize, Size, X, Y, Position, Velocity)

-- | Collision detection if an object protrudes out of monitor
isMonitorCollide :: MonitorSize -> Size -> X -> Y -> Boolean
isMonitorCollide ms objectSize x y
    = x < 0
    || x + objectSize.width - 1 > ms.width
    || y < 0
    || y + objectSize.height - 1 > ms.height

-- | Collision detection if an object completely protrudes out of monitor
isOutOfMonitor :: MonitorSize -> Size -> X -> Y -> Boolean
isOutOfMonitor ms objectSize x y
    = x + objectSize.width - 1 < 0
    || x > ms.width
    || y + objectSize.height - 1 < 0
    || y > ms.height

-- | Collision detection between two objects
isCollide :: Size -> X -> Y -> Size -> X -> Y -> Boolean
isCollide objectSizeA xA yA objectSizeB xB yB
    = pAlx <= pBrx
    && pBlx <= pArx
    && pAby <= pBty
    && pBby <= pAty
    where
        pAlx = xA
        pArx = xA + objectSizeA.width - 1
        pAby = yA
        pAty = yA + objectSizeA.height - 1 
        pBlx = xB
        pBrx = xB + objectSizeB.width - 1
        pBby = yB
        pBty = yB + objectSizeB.height - 1 

-- | Make asset data from raw maps.
-- | If there are unparsable strings, exception raised when executing javascript.
mkAsset :: Array RawMap -> Effect Asset
mkAsset rms = do
    ms <- orErrMsg $ traverse (\m -> parseTileMap m emojiToImage) rms 
    pure { mapData: ms}

-- | Empty asset for convenience. 
emptyAsset :: Asset
emptyAsset = { 
    mapData: []
}

defaultMonitorSize :: MonitorSize
defaultMonitorSize = { 
    width: 1280, 
    height: 720
}

updatePosition :: Position -> Velocity -> Position
updatePosition p v = { x: x, y: y }
    where
        x = floor $ (toNumber p.x) + v.xSpeed
        y = floor $ (toNumber p.y) + v.ySpeed
