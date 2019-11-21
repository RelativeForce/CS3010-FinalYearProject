module Emo8.Types where

import Data.Maybe (Maybe)
import Graphics.Canvas (Context2D)

type MonitorSize = Size

type Position = { 
  x :: X, 
  y :: Y
}

type Velocity = {
  xSpeed :: Number,
  ySpeed :: Number 
}

type Asset = { 
  mapData :: Array TileMap
}

type TileMap = Array (Array (Maybe ScaledImage))

type DrawContext = { 
  ctx :: Context2D, 
  mapData :: Array TileMap, 
  monitorSize :: MonitorSize
}
    
type ScaledImage = {
  id :: ImageId,
  image :: Image,
  size :: Size
}

type Sprite = {
  id :: ImageId,
  frames :: FrameArray,
  frameIndex :: Int,
  framesPerSecond :: FramesPerSecond,
  frameCount :: FrameCount,
  size :: Size
}

type Request = {
  url :: String,
  json :: String,
  method :: String
}

type Size = {
  width :: Width,
  height :: Height
}

type PlayerScoreCreateRequestData = {
  username :: String,
  score :: Int,
  start :: String,
  end :: String
}

type PlayerScore = {
    username :: String,
    score :: Int,
    time :: String,
    position :: Int
}

type Image = String
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
type Deg = Int
type Bpm = Int
type ImageId = Int
type MapId = Int
type Score = Int
type TextHeight = Int
