module Emo8.Constants where

import Emo8.Types (MonitorSize)

-- | The id string of the HTML tag containing the canvas
canvasId :: String
canvasId = "scene"

-- | The "sans-serif" font 
fontFamily :: String
fontFamily = "sans-serif"

-- | The dimensions of the default monitor before scaling in pixels.
defaultMonitorSize :: MonitorSize
defaultMonitorSize = { 
    width: 1280, 
    height: 720
}