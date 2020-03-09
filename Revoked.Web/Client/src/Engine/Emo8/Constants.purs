module Emo8.Constants where

import Emo8.Types (MonitorSize)

-- | Return "scene"
canvasId :: String
canvasId = "scene"

-- | Return "sans-serif"
fontFamily :: String
fontFamily = "sans-serif"

defaultMonitorSize :: MonitorSize
defaultMonitorSize = { 
    width: 1280, 
    height: 720
}