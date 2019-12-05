module Assets.Sprites.PlayerStandingRight.Sprite where

import Emo8.Types (Sprite)
import Assets.Sprites.PlayerStandingRight.Frame0 (frame0Data)
import Assets.AssetIds as Id

playerStandingRight ::  Sprite
playerStandingRight = {
    frames: [frame0Data],
    frameIndex: 0,
    framesPerSecond: 1,
    frameCount: 1,
    size: { 
        width: 24,
        height: 31
    },
    id: Id.playerStandingRightId
}