module Revoked.Assets.Sprites.PlayerStandingLeft.Sprite where

import Emo8.Types (Sprite)
import Revoked.Assets.Sprites.PlayerStandingLeft.Frame0 (frame0Data)
import Revoked.Assets.AssetIds as Id

playerStandingLeft ::  Sprite
playerStandingLeft = {
    frames: [frame0Data],
    frameIndex: 0,
    framesPerSecond: 1,
    frameCount: 1,
    size: { 
        width: 24,
        height: 31
    },
    id: Id.playerStandingLeftId
}