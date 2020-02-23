# Engine Usage Guide

## Game Class

```PureScript
class Game s where
  update :: Asset -> Input -> s -> Update s
  draw :: s -> Draw Unit
```

`s` is a game state data type which can be flexibly defined.

Each functions are executed in order update, draw, sound at every frame.

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

## Input

Defines the keyboard inputs that will be used for the game. This includes `A-Z`, `Space`, `Enter` and `Backspace`. All other keys are ignored.

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
```
Defines the state of each of the `InputFlags`.
- `active` refers to input keys that are were pressed or held down at the last input poll.
- `catched` refers to input keys that were pressed at the last input poll.
- `release` refers to input keys that were release at the last input poll.

```PureScript
type Input = { 
  active :: InputFlags,
  catched :: InputFlags, 
  released :: InputFlags
}
```

## FFI Modules

See [FFI Guide](\ffi.md)