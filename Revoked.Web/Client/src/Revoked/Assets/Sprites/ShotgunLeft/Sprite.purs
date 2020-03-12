module Revoked.Assets.Sprites.ShotgunLeft.Sprite where

import Emo8.Types (Sprite)
import Revoked.Assets.Sprites.ShotgunLeft.Frame0 (frame0Data)
import Revoked.Assets.AssetIds as Id

shotgunLeft ::  Sprite
shotgunLeft = {
    frames: [frame0Data],
    frameIndex: 0,
    framesPerSecond: 1,
    frameCount: 1,
    size: { 
        width: 32,
        height: 9
    },
    id: Id.shotgunLeftId
}