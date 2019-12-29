module Assets.Sprites.PistolRight.Sprite where

import Emo8.Types (Sprite)
import Assets.Sprites.PistolRight.Frame0 (frame0Data)
import Assets.AssetIds as Id

pistolRight ::  Sprite
pistolRight = {
    frames: [frame0Data],
    frameIndex: 0,
    framesPerSecond: 1,
    frameCount: 1,
    size: { 
        width: 17,
        height: 10
    },
    id: Id.pistolRightId
}