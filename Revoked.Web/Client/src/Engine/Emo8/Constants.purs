module Emo8.Constants where

import Emo8.Types (MonitorSize)

-- | Return "scene"
canvasId :: String
canvasId = "scene"

-- | Return "sans-serif"
fontFamily :: String
fontFamily = "sans-serif"

maxNoteSize :: Int
maxNoteSize = 5

targetFramesPerSecond :: Int
targetFramesPerSecond = 60

defaultMonitorSize :: MonitorSize
defaultMonitorSize = { 
    width: 1280, 
    height: 720
}