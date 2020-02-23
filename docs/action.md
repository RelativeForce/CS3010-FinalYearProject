# Action and Interpreter

Two free monads (`Draw`, `Update`) for wrapping non-pure operations into a sequence of discrete no-evaluated operations. These monads can be interpreted into a sequence of `Effect` operations. This allows `Effect` operations to be mocked for testing purposes.

## Action - Draw

Monad for wrapping non-pure functions for drawing images, sprites and text on the screen.

**Note**: Screen origin is bottom left.

### Draw Image with No Scaling
```PureScript
drawImageNoScaling :: Image -> X -> Y -> Draw Unit
```
Arguments
- `Image`: data-URI OR path to image
- `X`: horizontal displacement in pixels from the origin
- `Y`: vertical displacement in pixels from the origin

Returns
- `Draw Unit`: a simple draw action to be interpreted.

### Draw Scaled Image
```PureScript
drawScaledImage :: ScaledImage -> X -> Y -> Draw Unit
```
Arguments
- `ScaledImage`: image to be drawn
- `X`: horizontal displacement in pixels from the origin
- `Y`: vertical displacement in pixels from the origin

Returns
- `Draw Unit`: a simple draw action to be interpreted.

### Draw Rotated and Scaled Image
```PureScript
drawRotatedScaledImage :: ScaledImage -> X -> Y -> Deg -> Draw Unit
```
Arguments
- `ScaledImage`: image to be drawn
- `X`: horizontal displacement in pixels from the origin
- `Y`: vertical displacement in pixels from the origin
- `Deg`: angle from positive horizontal axis (right)

Returns
- `Draw Unit`: a simple draw action to be interpreted.
### Draw Sprite
```PureScript
drawSprite :: Sprite -> X -> Y -> Draw Unit
```
Arguments
- `Sprite`: [Sprite](types.md\#Sprite) to be drawn
- `X`: horizontal displacement in pixels from the origin
- `Y`: vertical displacement in pixels from the origin

Returns
- `Draw Unit`: a simple draw action to be interpreted.

### Draw Rotated Sprite
```PureScript
drawRotatedSprite :: Sprite -> X -> Y -> Deg -> Draw Unit
```
Arguments
- `Sprite`: [Sprite](types.md\#Sprite) to be drawn
- `X`: horizontal displacement in pixels from the origin
- `Y`: vertical displacement in pixels from the origin
- `Deg`: angle from positive horizontal axis (right)

Returns
- `Draw Unit`: a simple draw action to be interpreted.

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

Returns
- `Draw Unit`: a simple draw action to be interpreted.

### Draw Map
```PureScript
drawMap :: MapId -> Size -> X -> Y -> Draw Unit
```
Arguments
- `MapId`: the id of the map to be drawn
- `Size`: the size of the map
- `X`: horizontal displacement in pixels from the origin
- `Y`: vertical displacement in pixels from the origin

Returns
- `Draw Unit`: a simple draw action to be interpreted.

## Action - Update

Monad for wrapping non-pure functions required when updating the game state.

### Current DateTime

Retrieves the current date and time at the point of evaluation. 

```PureScript
nowDateTime :: Update DateTime
```

Returns
- `Update DateTime`: once interpreted, the current `DateTime`.

### Store Player Score

Stores a player score in persistent storage.

```PureScript
storePlayerScore :: PlayerScoreCreateRequestData -> Update (Either String Boolean)
```
Arguments
- `PlayerScoreCreateRequestData`: the player score data to be stored

Returns
- `Update (Either String Boolean)`: once interpreted, either a message (`String`) regarding the current in progress status of the request or the success status (`Boolean`) of the request.

### Retrieve Top Scores 
Retrieve the top X scores from persistent storage.

```PureScript
listTopScores :: Update (Either String (Array PlayerScore))
```
Returns
- `Update (Either String (Array PlayerScore))`: once interpreted, either a message (`String`) regarding the current in progress status of retriveing the top scores or an list (`Array`) of the top `PlayerScore`s in decending order.

### Start an AudioStream

Adds an `AudioStream` to the given `AudioContext` and start it. The `AudioStream` will be muted initially if the `AudioContext.muted` is true. Only one `AudioStream` of each audio source should be playing at once.

```PureScript
addAudioStream :: AudioContext -> String -> Update AudioContext
```
Arguments
- `AudioContext`: the audio context
- `String`: the source of the audio (network path to audio file)

Returns
- `Update AudioContext`: once interpreted, the audio context containing the new `AudioStream`

### Check if AudioStream is Playing

Checks if a `AudioStream` is currently playing in the `AudioContext`. If the audio stream has finished or has been stopped then this will be false.

```PureScript
isAudioStreamPlaying :: AudioContext -> String -> Update Boolean
```
Arguments
- `AudioContext`: the audio context
- `String`: the source of the audio (network path to audio file)
Returns
- `Update Boolean`: once interpreted, whether or not the specified `AudioStream` is currently playing. 

### Stoping running AudioStream

Ends a specified `AudioStream` in the given `AudioContext`.

```PureScript
stopAudioStream :: AudioContext -> String -> Update AudioContext
```
Arguments
- `AudioContext`: the audio context
- `String`: the source of the audio (network path to audio file)
Returns
- `Update AudioContext`: once interpreted, the audio context without the specified `AudioStream`

### Mute AudioContext

Mutes all the `AudioStream`s in the given `AudioContext`. If all `AudioStream`s are muted then this function does nothing.

```PureScript
muteAudio :: AudioContext -> Update AudioContext
```

Arguments
- `AudioContext`: the audio context

Returns
- `Update AudioContext`: once interpreted, the muted audio context

### Unmute AudioContext

Unmutes all the `AudioStream`s in the given `AudioContext`. If no `AudioStream`s are muted then this function does nothing.

```PureScript
unmuteAudio :: AudioContext -> Update AudioContext
```

Arguments
- `AudioContext`: the audio context

Returns
- `Update AudioContext`: once interpreted, the unmuted audio context