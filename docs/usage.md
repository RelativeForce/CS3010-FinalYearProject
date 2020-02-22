# Engine Usage Guide

## Game Class

```PureScript
class Game s where
  update :: Asset -> Input -> s -> Update s
  draw :: s -> Draw Unit
```

`s` is a game state data type which can be flexibly defined.

Each functions are executed in order update, draw, sound at every frame.

## Action - Update

### Input

```PureScript
type InputFlags = {
  isSpace :: Boolean,
  isEnter :: Boolean,
  isBackspace :: Boolean,
  isA :: Boolean,
  isB :: Boolean,  
  isC :: Boolean, 
  isD :: Boolean,
  ...
}

type Input = { 
  active :: InputFlags,
  catched :: InputFlags, 
  released :: InputFlags
}
```

## Action - Draw

Note: Screen origin is bottom left.

### Draw Image with No Scaling
```PureScript
drawImageNoScaling :: Image -> X -> Y -> Draw Unit
```
Arguments
- `Image`: data-URI OR path to image
- `X`: horizontal displacement in pixels from the origin
- `Y`: vertical displacement in pixels from the origin

### Draw Scaled Image
```PureScript
drawScaledImage :: ScaledImage -> X -> Y -> Draw Unit
```
Arguments
- `ScaledImage`: image to be drawn
- `X`: horizontal displacement in pixels from the origin
- `Y`: vertical displacement in pixels from the origin

### Draw Rotated and Scaled Image
```PureScript
drawRotatedScaledImage :: ScaledImage -> X -> Y -> Deg -> Draw Unit
```
Arguments
- `ScaledImage`: image to be drawn
- `X`: horizontal displacement in pixels from the origin
- `Y`: vertical displacement in pixels from the origin
- `Deg`: angle from positive horizontal axis (right)

### Draw Sprite
```PureScript
drawSprite :: Sprite -> X -> Y -> Draw Unit
```
Arguments
- `Sprite`: [Sprite](types.md\#Sprite) to be drawn
- `X`: horizontal displacement in pixels from the origin
- `Y`: vertical displacement in pixels from the origin

### Draw Rotated Sprite
```PureScript
drawRotatedSprite :: Sprite -> X -> Y -> Deg -> Draw Unit
```
Arguments
- `Sprite`: [Sprite](types.md\#Sprite) to be drawn
- `X`: horizontal displacement in pixels from the origin
- `Y`: vertical displacement in pixels from the origin
- `Deg`: angle from positive horizontal axis (right)

### Draw Text
```PureScript
drawText :: String -> TextHeight -> X -> Y -> Color -> Draw Unit
```
Arguments
- `String`: text to be drawn
- `TextHeight`: see [TextHeight](types.md\#TextHeight)
- `X`: horizontal displacement in pixels from the origin
- `Y`: vertical displacement in pixels from the origin
- `Color`: hex-code color of the text

### Draw Map
```PureScript
drawMap :: MapId -> Size -> X -> Y -> Draw Unit
```
Arguments
- `MapId`: the id of the map to be drawn
- `Size`: the size of the map
- `X`: horizontal displacement in pixels from the origin
- `Y`: vertical displacement in pixels from the origin

## Map

```PureScript
exampleMap :: RawMap
exampleMap = RawMap """
🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳
🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳
🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳
🈳🈳🈳🈳🈳🈳🈳🈚🈚🈳🈳🈳🈳🈳🈳🈳
🈳🈳🈳🈳🈳🈳🈳🈚🈚🈳🈳🈳🈳🈳🈳🈳
🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳
🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳
🈵🈵🈵🈵🈳🈳🈳🈳🈳🈳🈳🈳🈵🈵🈵🈵
🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳
🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳
🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳
🈳🈳🈳🈳🈵🈵🈵🈵🈵🈵🈵🈵🈳🈳🈳🈳
🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳
🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳
🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳
🈵🈵🈵🈵🈵🈵🈵🈵🈵🈵🈵🈵🈵🈵🈵🈵
"""
```
Each emoji is mapped to a tile image and drawn in the position shown. Line wrapping may effect how the map is displayed in the code editor but will not effect how it is parsed. <br>
**Note:** 🈳 is the special emoji that represents vacant space.

## Asset

See type [Asset](types.md\#Asset) and use `mkAsset` function for loading map that you edited.

```PureScript
mkAsset :: Array RawMap -> Effect Asset
```

## Game Loop

Starts the main game loop that will continuously render the game on the canvas until the web page is closed or the canvas becomes unavaiable.

```PureScript
emo8 :: forall s. Game s => s -> Asset -> MonitorSize -> Effect Unit
```

## ServerIO

Requires `var serverLocalStore = [];` to be defined on the web page (or a preceeding JavaScript file).

Sends a [Request](types.md\#Request) object to via a AJAX request. This function should be repeatedly polled. If the request does not exist in the local store when polled, the specified request will be sent to the server and `Left "Waiting"` will be returned meaning that the request is still waiting for a response. When the response is received from the server it is stored in the local store. When the function is next polled the response obeject will be returned as `Right a` where `a` is the expected response.

```PureScript
send :: forall a. Request -> Effect (Either String a)
```

## AudioController

An abstraction for the audio context which allows `AudioStream`s to be created, stopped, muted and unmuted. The audio elements are appended to the body and stored in the `AudioController`.

```PureScript
newAudioController :: String -> AudioController

muteAudio :: AudioController -> Effect AudioController

unmuteAudio :: AudioController -> Effect AudioController

addAudioStream :: AudioController -> String -> Effect AudioController

isAudioStreamPlaying :: AudioController -> String -> Effect Boolean

stopAudioStream :: AudioController -> String -> Effect AudioController
```