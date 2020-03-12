module Revoked.Assets.Sprites.PistolBullet.Sprite where

import Emo8.Types (Sprite)
import Revoked.Assets.Sprites.PistolBullet.Frame0 (frame0Data)
import Revoked.Assets.AssetIds as Id

pistolBullet ::  Sprite
pistolBullet = {
    frames: [frame0Data],
    frameIndex: 0,
    framesPerSecond: 1,
    frameCount: 1,
    size: {
        width: 10,
        height: 10
    },
    id: Id.pistolBulletId
}