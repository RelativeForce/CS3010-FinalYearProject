# FFI modules

These modules are PureScript wrapper modules for JavaScript functionality. Below are guides to the external APIs for the FFI modules added during this project. These modules were implemented in this way as the required functionality was not implememnted in an open-source module or the open-source module did not intergrate with the game functionality well.

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