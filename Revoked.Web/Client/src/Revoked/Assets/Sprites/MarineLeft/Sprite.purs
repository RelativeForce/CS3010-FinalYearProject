module Revoked.Assets.Sprites.MarineLeft.Sprite where

import Emo8.Types (Sprite)
import Revoked.Assets.Sprites.MarineLeft.Frame0 (frame0Data)
import Revoked.Assets.Sprites.MarineLeft.Frame1 (frame1Data)
import Revoked.Assets.Sprites.MarineLeft.Frame2 (frame2Data)
import Revoked.Assets.AssetIds as Id

marineLeft :: Sprite
marineLeft = {
    frames: [ frame0Data, frame1Data, frame2Data ],
    frameIndex: 0,
    framesPerSecond: 2,
    frameCount: 3,
    size: {
        width: 24,
        height: 31
    },
    id: Id.marineLeftId
}