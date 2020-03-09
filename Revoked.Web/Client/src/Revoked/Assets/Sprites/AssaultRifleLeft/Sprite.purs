module Revoked.Assets.Sprites.AssaultRifleLeft.Sprite where

import Emo8.Types (Sprite)
import Revoked.Assets.Sprites.AssaultRifleLeft.Frame0 (frame0Data)
import Revoked.Assets.AssetIds as Id

assaultRifleLeft ::  Sprite
assaultRifleLeft = {
    frames: [frame0Data],
    frameIndex: 0,
    framesPerSecond: 1,
    frameCount: 1,
    size: { 
        width: 32,
        height: 9
    },
    id: Id.assaultRifleLeftId
}