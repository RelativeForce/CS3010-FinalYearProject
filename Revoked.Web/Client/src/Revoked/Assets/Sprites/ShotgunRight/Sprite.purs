module Assets.Sprites.ShotgunRight.Sprite where

import Emo8.Types (Sprite)
import Assets.Sprites.ShotgunRight.Frame0 (frame0Data)
import Assets.AssetIds as Id

shotgunRight ::  Sprite
shotgunRight = {
    frames: [frame0Data],
    frameIndex: 0,
    framesPerSecond: 1,
    frameCount: 1,
    size: { 
        width: 32,
        height: 9
    },
    id: Id.shotgunRightId
}