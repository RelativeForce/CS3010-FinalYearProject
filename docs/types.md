# Types Guide

### Image
**Use:** The data-URI OR network path to image.<br>
**Note:** Using network paths will cause the asset to be redownloaded to the clients if the clients cache is disabled.
```PureScript
type Image = String
```
### X
**Use:** A horizontal displacement in number of pixels.<br>
**Note:** Can be negative value.
```PureScript
type X = Int
```
### Y
**Use:** A vertical displacement in number of pixels.<br>
**Note:** Can be negative value.
```PureScript
type Y = Int
```
### Width
**Use:** A horizontal width of an object in number of pixels.<br>
**Note:** Cannot be negative.
```PureScript
type Width = Int
```
### Height
**Use:** A vertical height of an object in number of pixels.<br>
**Note:** Cannot be negative.
```PureScript
type Height = Int
```
### FrameCount
**Use:** The number of [Frames](#Image) in a [FrameArray](#FrameArray)<br>
**Note:** Cannot be negative.
```PureScript
type FrameCount = Int
```
### FramesPerSecond
**Use:** The number of screen updates that a [Frames](#Image) in a [FrameArray](#FrameArray) will be displayed for before transitioning to the next frame.<br>
**Note:** Cannot be negative.
```PureScript
type FramesPerSecond = Int
```
### FrameArray
**Use:** A collection of [Frames](#Image)<br>
```PureScript
type FrameArray = Array Image
```
### Deg
**Use:** A angle in degrees.<br>
```PureScript
type Deg = Int
```
### AssetId
**Use:** A value that uniquely identifies a in-game asset ([Image](#Image) or [Sprite](#Sprite)).<br>
```PureScript
type AssetId = Int
```
### StateId
**Use:** A value that uniquely identifies a game state.<br>
```PureScript
type StateId = Int
```
### MapId
**Use:** A value that uniquely identifies a [TileMap](#TileMap).<br>
```PureScript
type MapId = Int
```
### Score
**Use:** In game score<br>
```PureScript
type Score = Int
```
### TextHeight
**Use:** The height text should be in pixels when displayed on screen.
```PureScript
type TextHeight = Int
```
### MonitorSize
**Use:** The [Size](#Size) of the canvas the game will be drawn on.
```PureScript
type MonitorSize = Size
```
### Vector
**Use:** A change in [X](#X) and [Y](#Y) coordinates.
```PureScript
type Vector = Position
```
### Position
**Use:** A position relative with [X](#X) and [Y](#Y) coordinates.
```PureScript
type Position = { 
  x :: X, 
  y :: Y
}
```
### Velocity
**Use:** A speed with direction defined by a horizontal and vertical component.
```PureScript
type Velocity = {
  xSpeed :: Number,
  ySpeed :: Number 
}
```
### Asset
**Use:** A collection of [TileMaps](#TileMap)
```PureScript
type Asset = { 
  mapData :: Array TileMap
}
```
### TileMap
**Use:** A 2D array of [ScaledImages](#ScaledImage). Any cell that is `Nothing` represents an empty tile.
```PureScript
type TileMap = Array (Array (Maybe ScaledImage))
```
### DrawContext
**Use:** A graphical context for drawning [TileMaps](#TileMap) on a monitor with a defined [Size](#Size) given a `Context2D`.
```PureScript
type DrawContext = { 
  ctx :: Context2D, 
  mapData :: Array TileMap, 
  monitorSize :: MonitorSize
}
```
### ScaledImage
**Use:** A [Image](#Image) with a defined [Size](#Size) and [AssetId](#AssetId).
```PureScript
type ScaledImage = {
  id :: AssetId,
  image :: Image,
  size :: Size
}
```
### Sprite
**Use:** A [FrameArray](#FrameArray) that can be iterated through. Each of the images in the [FrameArray](#FrameArray) will be scaled to the specified [Size](#Size) when drawn.<br>
**Note:** `frameIndex` cannot be negative and `frameCount` should be the length of `frames`.
```PureScript
type Sprite = {
  id :: AssetId,
  frames :: FrameArray,
  frameIndex :: Int,
  framesPerSecond :: FramesPerSecond,
  frameCount :: FrameCount,
  size :: Size
}
```
### Request
**Use:** An API request.
```PureScript
type Request = {
  url :: String,
  json :: String,
  method :: String
}
```
### Size
**Use:** A wrapping type for an object's [Width](#Width) and [Height](#Height).
```PureScript
type Size = {
  width :: Width,
  height :: Height
}
```
### PlayerScoreCreateRequestData
**Use:** An API request for storing a player's score and time.
```PureScript
type PlayerScoreCreateRequestData = {
  username :: String,
  score :: Int,
  start :: String,
  end :: String
}
```
### PlayerScore
**Use:** An API reqponse containg the details of a player's highscore.
```PureScript
type PlayerScore = {
    username :: String,
    score :: Int,
    time :: String,
    position :: Int
}
```