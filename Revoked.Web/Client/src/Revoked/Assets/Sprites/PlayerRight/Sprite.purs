module Revoked.Assets.Sprites.PlayerRight.Sprite where

import Emo8.Types (Sprite)
import Revoked.Assets.Sprites.PlayerRight.Frame0 (frame0Data)
import Revoked.Assets.Sprites.PlayerRight.Frame1 (frame1Data)
import Revoked.Assets.Sprites.PlayerRight.Frame2 (frame2Data)
import Revoked.Assets.AssetIds as Id

playerRight :: Sprite
playerRight = {
    frames: [ frame0Data, frame1Data, frame2Data ],
    frameIndex: 0,
    framesPerSecond: 1,
    frameCount: 3,
    size: {
        width: 24,
        height: 31
    },
    id: Id.playerRightId
}