module Assets.Sprites.PlayerLeft.Sprite where

import Emo8.Types (Sprite)
import Assets.Sprites.PlayerLeft.Frame0 (frame0Data)
import Assets.Sprites.PlayerLeft.Frame1 (frame1Data)
import Assets.Sprites.PlayerLeft.Frame2 (frame2Data)
import Assets.AssetIds as Id

playerLeft :: Sprite
playerLeft = {
    frames: [ frame0Data, frame1Data, frame2Data ],
    frameIndex: 0,
    framesPerSecond: 1,
    frameCount: 3,
    size: {
        width: 24,
        height: 31
    },
    id: Id.playerLeftId
}