# Action and Interpreter

Two free monads (`Draw`, `Update`) for wrapping non-pure operations into a sequence of discrete no-evaluated operations. These monads can be interpreted into a sequence of `Effect` operations. This allows `Effect` operations to be mocked for testing purposes.

## Action - Draw

Monad for wrapping non-pure functions for drawing images, sprites and text on the screen.

**Note**: Screen origin is bottom left.

### Draw Image with No Scaling
```PureScript
drawImageNoScaling :: Image -> X -> Y -> Draw Unit
```
- `Image`: data-URI OR path to image
- `X`: horizontal displacement in pixels from the origin
- `Y`: vertical displacement in pixels from the origin

### Draw Scaled Image
```PureScript
drawScaledImage :: ScaledImage -> X -> Y -> Draw Unit
```
- `ScaledImage`: image to be drawn
- `X`: horizontal displacement in pixels from the origin
- `Y`: vertical displacement in pixels from the origin

### Draw Rotated and Scaled Image
```PureScript
drawRotatedScaledImage :: ScaledImage -> X -> Y -> Deg -> Draw Unit
```
- `ScaledImage`: image to be drawn
- `X`: horizontal displacement in pixels from the origin
- `Y`: vertical displacement in pixels from the origin
- `Deg`: angle from positive horizontal axis (right)

### Draw Sprite
```PureScript
drawSprite :: Sprite -> X -> Y -> Draw Unit
```
- `Sprite`: [Sprite](types.md\#Sprite) to be drawn
- `X`: horizontal displacement in pixels from the origin
- `Y`: vertical displacement in pixels from the origin

### Draw Rotated Sprite
```PureScript
drawRotatedSprite :: Sprite -> X -> Y -> Deg -> Draw Unit
```
- `Sprite`: [Sprite](types.md\#Sprite) to be drawn
- `X`: horizontal displacement in pixels from the origin
- `Y`: vertical displacement in pixels from the origin
- `Deg`: angle from positive horizontal axis (right)

### Draw Text
```PureScript
drawText :: String -> TextHeight -> X -> Y -> Color -> Draw Unit
```
- `String`: text to be drawn
- `TextHeight`: see [TextHeight](types.md\#TextHeight)
- `X`: horizontal displacement in pixels from the origin
- `Y`: vertical displacement in pixels from the origin
- `Color`: hex-code color of the text

### Draw Map
```PureScript
drawMap :: MapId -> Size -> X -> Y -> Draw Unit
```
- `MapId`: the id of the map to be drawn
- `Size`: the size of the map
- `X`: horizontal displacement in pixels from the origin
- `Y`: vertical displacement in pixels from the origin

## Action - Update

Monad for wrapping non-pure functions required when updating the game state.

### Current DateTime

```PureScript
nowDateTime :: Update DateTime
```

### Store Player Score

```PureScript
storePlayerScore :: PlayerScoreCreateRequestData -> Update (Either String Boolean)
```

### Retrieve Top Scores 

```PureScript
listTopScores :: Update (Either String (Array PlayerScore))
```

### Start an AudioStream

```PureScript
addAudioStream :: AudioContext -> String -> Update AudioContext
```

### Check if AudioStream is Playing

```PureScript
isAudioStreamPlaying :: AudioContext -> String -> Update Boolean
```

```PureScript
stopAudioStream :: AudioContext -> String -> Update AudioContext
```

```PureScript
muteAudio :: AudioContext -> Update AudioContext
```

```PureScript
unmuteAudio :: AudioContext -> Update AudioContext
```