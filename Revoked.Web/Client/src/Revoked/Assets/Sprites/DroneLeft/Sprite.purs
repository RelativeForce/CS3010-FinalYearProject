module Revoked.Assets.Sprites.DroneLeft.Sprite where

import Emo8.Types (Sprite)
import Revoked.Assets.Sprites.DroneLeft.Frame0 (frame0Data)
import Revoked.Assets.Sprites.DroneLeft.Frame1 (frame1Data)
import Revoked.Assets.Sprites.DroneLeft.Frame2 (frame2Data)
import Revoked.Assets.Sprites.DroneLeft.Frame3 (frame3Data)
import Revoked.Assets.AssetIds as Id

droneLeft :: Sprite
droneLeft = {
    frames: [ frame0Data, frame1Data, frame2Data, frame3Data ],
    frameIndex: 0,
    framesPerSecond: 2,
    frameCount: 4,
    size: {
        width: 64,
        height: 20
    },
    id: Id.droneLeftId
}