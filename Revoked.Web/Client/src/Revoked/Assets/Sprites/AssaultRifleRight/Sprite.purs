module Revoked.Assets.Sprites.AssaultRifleRight.Sprite where

import Emo8.Types (Sprite)
import Revoked.Assets.Sprites.AssaultRifleRight.Frame0 (frame0Data)
import Revoked.Assets.AssetIds as Id

assaultRifleRight ::  Sprite
assaultRifleRight = {
    frames: [frame0Data],
    frameIndex: 0,
    framesPerSecond: 1,
    frameCount: 1,
    size: { 
        width: 32,
        height: 9
    },
    id: Id.assaultRifleRightId
}