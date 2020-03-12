module Revoked.Assets.Sprites.DroneRight.Sprite where

import Emo8.Types (Sprite)
import Revoked.Assets.Sprites.DroneRight.Frame0 (frame0Data)
import Revoked.Assets.Sprites.DroneRight.Frame1 (frame1Data)
import Revoked.Assets.Sprites.DroneRight.Frame2 (frame2Data)
import Revoked.Assets.Sprites.DroneRight.Frame3 (frame3Data)
import Revoked.Assets.AssetIds as Id

droneRight :: Sprite
droneRight = {
    frames: [ frame0Data, frame1Data, frame2Data, frame3Data ],
    frameIndex: 0,
    framesPerSecond: 2,
    frameCount: 4,
    size: {
        width: 64,
        height: 20
    },
    id: Id.droneRightId
}