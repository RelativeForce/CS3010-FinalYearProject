module Revoked.Assets.Sprites.Blaster.Sprite where

import Emo8.Types (Sprite)
import Revoked.Assets.Sprites.Blaster.Frame0 (frame0Data)
import Revoked.Assets.AssetIds as Id

blaster :: Sprite
blaster = {
    frames: [frame0Data],
    frameIndex: 0,
    framesPerSecond: 1,
    frameCount: 1,
    size: {
        width: 17,
        height: 4
    },
    id: Id.blasterId
}