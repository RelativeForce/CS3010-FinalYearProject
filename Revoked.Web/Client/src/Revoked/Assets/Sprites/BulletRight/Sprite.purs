module Assets.Sprites.BulletRight.Sprite where

import Emo8.Types (Sprite)
import Assets.Sprites.BulletRight.Frame0 (frame0Data)
import Assets.AssetIds as Id

bulletRight ::  Sprite
bulletRight = {
    frames: [frame0Data],
    frameIndex: 0,
    framesPerSecond: 1,
    frameCount: 1,
    width: 32,
    height: 32,
    id: Id.bulletSpriteForwardId
}