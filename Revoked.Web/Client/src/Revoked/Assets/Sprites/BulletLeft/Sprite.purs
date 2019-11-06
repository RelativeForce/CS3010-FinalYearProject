module Assets.Sprites.BulletLeft.Sprite where

import Emo8.Types (Sprite)
import Assets.Sprites.BulletLeft.Frame0 (frame0Data)
import Assets.AssetIds as Id

bulletLeft ::  Sprite
bulletLeft = {
    frames: [frame0Data],
    frameIndex: 0,
    framesPerSecond: 1,
    frameCount: 1,
    width: 32,
    height: 32,
    id: Id.bulletSpriteBackwardId
}