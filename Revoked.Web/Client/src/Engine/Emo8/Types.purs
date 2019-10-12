module Emo8.Types where

import Audio.WebAudio.Types (AudioContext)
import Emo8.Data.Emoji (Emoji)
import Emo8.Data.Tick (Tick)
import Emo8.SoundUtil (ChannelSets)
import Graphics.Canvas (Context2D)

type MonitorSize = { 
  width :: Width, 
  height :: Height
}

type Position = { 
  x :: X, 
  y :: Y
}

-- | Asset type.
-- | It contains map data and sound data.
type Asset = { 
  mapData :: Array EmojiMap, 
  soundData :: Array Sound
}

type EmojiMap = Array (Array Emoji)
type Sound = Array Tick

type DrawContext = { 
  ctx :: Context2D, 
  mapData :: Array EmojiMap, 
  monitorSize :: MonitorSize
}

type SoundContext = { 
  ctx :: AudioContext, 
  soundData :: Array Sound, 
  channelSets :: ChannelSets
}

type Image = String
    
type ScaledImage = {
  image :: Image,
  width :: Width,
  height :: Height
}

type Sprite = {
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

type MapId = Int
type SoundId = Int
