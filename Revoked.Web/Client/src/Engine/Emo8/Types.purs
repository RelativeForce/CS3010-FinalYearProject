module Emo8.Types where

import Audio.WebAudio.Types (AudioContext)
import Emo8.Data.Tick (Tick)
import Emo8.SoundUtil (ChannelSets)
import Graphics.Canvas (Context2D)
import Data.Maybe (Maybe)

type MonitorSize = { 
  width :: Width, 
  height :: Height
}

type Position = { 
  x :: X, 
  y :: Y
}

type Velocity = {
  xSpeed :: Number,
  ySpeed :: Number 
}

-- | Asset type.
-- | It contains map data and sound data.
type Asset = { 
  mapData :: Array TileMap, 
  soundData :: Array Sound
}

type TileMap = Array (Array (Maybe ScaledImage))
type Sound = Array Tick

type DrawContext = { 
  ctx :: Context2D, 
  mapData :: Array TileMap, 
  monitorSize :: MonitorSize
}

type SoundContext = { 
  ctx :: AudioContext, 
  soundData :: Array Sound, 
  channelSets :: ChannelSets
}

type Image = String
    
type ScaledImage = {
  id :: ImageId,
  image :: Image,
  width :: Width,
  height :: Height
}

type Sprite = {
  id :: ImageId,
  frames :: FrameArray,
  frameIndex :: Int,
  framesPerSecond :: FramesPerSecond,
  frameCount :: FrameCount,
  width :: Width,
  height :: Height
}

type X = Int
type Y = Int
type Width = Int
type Height = Int
type FrameCount = Int
type FramesPerSecond = Int
type FolderPath = String
type FrameArray = Array String
type IdX = Int
type IdY = Int
type Size = Int
type Deg = Int
type Bpm = Int

type ImageId = Int
type MapId = Int
type SoundId = Int
