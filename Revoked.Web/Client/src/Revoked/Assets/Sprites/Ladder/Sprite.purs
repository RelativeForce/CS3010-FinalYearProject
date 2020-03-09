module Revoked.Assets.Sprites.Ladder.Sprite where

import Emo8.Types (Sprite)
import Revoked.Assets.Sprites.Ladder.Frame0 (frame0Data)
import Revoked.Assets.AssetIds as Id

ladder :: Sprite
ladder = {
    frames: [frame0Data],
    frameIndex: 0,
    framesPerSecond: 1,
    frameCount: 1,
    size: {
        width: 18,
        height: 36
    },
    id: Id.ladderId
}