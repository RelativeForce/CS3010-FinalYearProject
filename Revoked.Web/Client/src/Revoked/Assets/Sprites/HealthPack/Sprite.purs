module Revoked.Assets.Sprites.HealthPack.Sprite where

import Emo8.Types (Sprite)
import Revoked.Assets.Sprites.HealthPack.Frame0 (frame0Data)
import Revoked.Assets.AssetIds as Id

healthPack :: Sprite
healthPack = {
    frames: [frame0Data],
    frameIndex: 0,
    framesPerSecond: 1,
    frameCount: 1,
    size: {
        width: 25,
        height: 25
    },
    id: Id.healthPackId
}