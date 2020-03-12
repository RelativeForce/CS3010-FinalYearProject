module Revoked.Assets.Sprites.MarineStanding.Sprite where

import Emo8.Types (Sprite)
import Revoked.Assets.Sprites.MarineStanding.Frame0 (frame0Data)
import Revoked.Assets.AssetIds as Id

marineStanding :: Sprite
marineStanding = {
    frames: [frame0Data],
    frameIndex: 0,
    framesPerSecond: 1,
    frameCount: 1,
    size: {
        width: 24,
        height: 31
    },
    id: Id.marineStandingId
}