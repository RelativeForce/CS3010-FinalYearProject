module Assets.Sprites.BulletLeft.Sprite where

import Emo8.Types (Sprite)
import Assets.Sprites.BulletLeft.Frame0 (frame0Data)
import Assets.Sprites.BulletLeft.Frame1 (frame1Data)
import Assets.AssetIds as Id

bulletLeft ::  Sprite
bulletLeft = {
    frames: [frame0Data, frame1Data],
    frameIndex: 0,
    framesPerSecond: 2,
    frameCount: 2,
    size: {
        width: 18,
        height: 10
    },
    id: Id.bulletSpriteBackwardId
}