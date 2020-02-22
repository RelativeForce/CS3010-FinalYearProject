# Engine Usage Guide

## Game Class

```PureScript
class Game s where
  update :: Asset -> Input -> s -> Update s
  draw :: s -> Draw Unit
```

`s` is a game state data type which can be flexibly defined.

Each functions are executed in order update, draw, sound at every frame.

## Update Action

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

## Draw Action

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

- `ScaledImage`: image to be displayed
- `X`: horizontal displacement in pixels from the origin
- `Y`: vertical displacement in pixels from the origin


## Map Edit

```PureScript
map0 :: RawMap
map0 = RawMap """
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

※ 🈳 is the special emoji that represents vacant space.

## Sound Edit

```PureScript
sound0 :: RawSound
sound0 = RawSound """
🎼🔈5️⃣🎹🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳
🎼🔈5️⃣🈳🎹🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳
🎼🔈5️⃣🈳🈳🎹🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳
🎼🔈5️⃣🈳🈳🈳🎹🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳
🎼🔈5️⃣🈳🈳🈳🈳🎹🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳
🎼🔈5️⃣🈳🈳🈳🈳🈳🎹🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳
🎼🔈5️⃣🈳🈳🈳🈳🈳🈳🎹🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳
🎼🔈5️⃣🈳🈳🈳🈳🈳🈳🈳🎹🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳
🎼🔈5️⃣🈳🈳🈳🈳🈳🈳🈳🈳🎹🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳
🎼🔈5️⃣🈳🈳🈳🈳🈳🈳🈳🈳🈳🎹🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳
🎼🔈5️⃣🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🎹🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳
🎼🔈5️⃣🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🎹🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳
🎼🔈5️⃣🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🎹🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳
"""
```

- First column: effect (🎼: None, 🎛: Detune)
- Second column: Volume (🔇: Mute ~ 🔊: High)
- Third column: octave (1️⃣: Octave 1 ~ 7️⃣: Octave 7)
- Forth~ columns: codes (🎹: play, 🈳: not play)

※ Max play codes per line: 5

※ Octave orders: 1 -> 2 -> 3 -> 4 -> 5 -> 6 -> 7 -> 1 (loop)

### Code Mean Examples

```plain
4️⃣🎹🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳: means C4 (261.626xxx Hz)
4️⃣🈳🈳🈳🈳🈳🈳🈳🈳🈳🎹🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳: means A4 (440 Hz)
5️⃣🎹🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳: means C5 (523.251xxx Hz)
5️⃣🈳🈳🈳🈳🈳🈳🈳🈳🈳🎹🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳: means A5 (880 Hz)

4️⃣🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🎹🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳: means C5 (523.251xxx Hz)
5️⃣🎹🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳: means C5 (523.251xxx Hz)
5️⃣🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🎹🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳: means C6 (1046.502xxx Hz)
6️⃣🎹🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳: means C6 (1046.502xxx Hz)

5️⃣🎹🈳🈳🈳🎹🈳🈳🎹🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳: means C5 major chord
5️⃣🈳🈳🎹🈳🈳🎹🈳🈳🈳🎹🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳: means D5 minor chord
```

## Asset

```PureScript
type Asset =
  { mapData :: Array EmojiMap
  , soundData :: Array Sound
  }
```

It contains map data and sound data.

Use `mkAsset` function for loading map and sound data that you edited.

```PureScript
mkAsset :: Array RawMap -> Array RawSound -> Effect Asset
```

## Development And Production

### Production

Main game loop function.

```PureScript
emo8 :: forall s. Game s => s -> Asset -> MonitorSize -> Effect Unit
```

### Development

Main game loop function for development.

```PureScript
emo8Dev :: forall s. GameDev s => s -> Asset -> MonitorSize -> Effect Unit
```

### GameDev Class

```PureScript
class (Game s, Encode s, Decode s) <= GameDev s where
    saveLocal :: s -> Array LocalKey
```

saveLocal function is executed after Game class's functions at every frame.
It saves state json text to localstorage with the given LocalKey array(for multiple savepoints).

### Load Saved State

```PureScript
loadStateWithDefault :: forall s. GameDev s => s -> LocalKey -> Effect s
```

Arguments

- s: fallback state which is used when localstorage key is not found.
- LocalKey: localstorage key which you saved with saveLocal function.
