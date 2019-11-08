module Assets.Sprites.BulletRight.Sprite where

import Emo8.Types (Sprite)
import Assets.Sprites.BulletRight.Frame0 (frame0Data)
import Assets.Sprites.BulletRight.Frame1 (frame1Data)
import Assets.AssetIds as Id

bulletRight ::  Sprite
bulletRight = {
    frames: [frame0Data, frame1Data],
    frameIndex: 0,
    framesPerSecond: 2,
    frameCount: 2,
    size: {
        width: 18,
        height: 10
    },
    id: Id.bulletForwardId
}