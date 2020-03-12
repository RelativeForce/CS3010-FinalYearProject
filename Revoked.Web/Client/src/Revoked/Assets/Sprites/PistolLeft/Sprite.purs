module Revoked.Assets.Sprites.PistolLeft.Sprite where

import Emo8.Types (Sprite)
import Revoked.Assets.Sprites.PistolLeft.Frame0 (frame0Data)
import Revoked.Assets.AssetIds as Id

pistolLeft ::  Sprite
pistolLeft = {
    frames: [frame0Data],
    frameIndex: 0,
    framesPerSecond: 1,
    frameCount: 1,
    size: { 
        width: 17,
        height: 10
    },
    id: Id.pistolLeftId
}