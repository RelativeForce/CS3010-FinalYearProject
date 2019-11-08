module Assets.Sprites.Player.Sprite where

import Emo8.Types (Sprite)
import Assets.Sprites.Player.Frame0 (frame0Data)
import Assets.AssetIds as Id

player ::  Sprite
player = {
    frames: [frame0Data],
    frameIndex: 0,
    framesPerSecond: 1,
    frameCount: 1,
    size: { 
        width: 32,
        height: 32
    },
    id: Id.playerSpriteId
}