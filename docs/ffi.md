# FFI modules

These modules are PureScript wrapper modules for JavaScript functionality. Below are guides to the external APIs for the FFI modules added during this project. These modules were implemented in this way as the required functionality was not implememnted in an open-source module or the open-source module did not intergrate with the game functionality well.

## ServerIO

Requires `var serverLocalStore = [];` to be defined on the web page (or a preceeding JavaScript file).

Sends a [Request](types.md\#Request) object to via a AJAX request. This function should be repeatedly polled. If the request does not exist in the local store when polled, the specified request will be sent to the server and `Left "Waiting"` will be returned meaning that the request is still waiting for a response. When the response is received from the server it is stored in the local store. When the function is next polled the response obeject will be returned as `Right a` where `a` is the expected response.

```PureScript
send :: forall a. Request -> Effect (Either String a)
```

## AudioController

An abstraction for the audio context which allows `AudioStream`s to be created, stopped, muted and unmuted. The audio elements are appended to the body and stored in the `AudioContext`.

### Create AudioContext

Creates a new `AudioContext` with a given Id `String`.

```PureScript
newAudioContext :: String -> AudioContext
```

Arguments
- `String`: the id of the new `AudioContext`

Returns
- `Effect AudioContext`: once evaluated, the new audio context 

### Mute AudioContext

Mutes all the `AudioStream`s in the given `AudioContext`. If all `AudioStream`s are muted then this function does nothing.

```PureScript
muteAudio :: AudioContext -> Effect AudioContext
```

Arguments
- `AudioContext`: the audio context

Returns
- `Effect AudioContext`: once evaluated, the muted audio context

### Unmute AudioContext

Unmutes all the `AudioStream`s in the given `AudioContext`. If no `AudioStream`s are muted then this function does nothing.

```PureScript
unmuteAudio :: AudioContext -> Effect AudioContext
```

Arguments
- `AudioContext`: the audio context

Returns
- `Effect AudioContext`: once evaluated, the unmuted audio context

### Start an AudioStream

Adds an `AudioStream` to the given `AudioContext` and start it. The `AudioStream` will be muted initially if the `AudioContext.muted` is true. Only one `AudioStream` of each audio source should be playing at once.

```PureScript
addAudioStream :: AudioContext -> String -> Effect AudioContext
```
Arguments
- `AudioContext`: the audio context
- `String`: the source of the audio (network path to audio file)

Returns
- `Effect AudioContext`: once evaluated, the audio context containing the new `AudioStream`

### Check if AudioStream is Playing

Checks if a `AudioStream` is currently playing in the `AudioContext`. If the audio stream has finished or has been stopped then this will be false.

```PureScript
isAudioStreamPlaying :: AudioContext -> String -> Effect Boolean
```
Arguments
- `AudioContext`: the audio context
- `String`: the source of the audio (network path to audio file)
Returns
- `Effect Boolean`: once evaluated, whether or not the specified `AudioStream` is currently playing. 

### Stoping running AudioStream

Ends a specified `AudioStream` in the given `AudioContext`.

```PureScript
stopAudioStream :: AudioContext -> String -> Effect AudioContext
```
Arguments
- `AudioContext`: the audio context
- `String`: the source of the audio (network path to audio file)
Returns
- `Effect AudioContext`: once evaluated, the audio context without the specified `AudioStream`