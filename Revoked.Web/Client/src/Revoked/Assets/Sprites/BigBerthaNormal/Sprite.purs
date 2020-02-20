module Assets.Sprites.BigBerthaNormal.Sprite where

import Emo8.Types (Sprite)
import Assets.Sprites.BigBerthaNormal.Frame0 (frame0Data)
import Assets.AssetIds as Id

bigBerthaNormal :: Sprite
bigBerthaNormal = {
    frames: [frame0Data],
    frameIndex: 0,
    framesPerSecond: 1,
    frameCount: 1,
    size: {
        width: 134,
        height: 50
    },
    id: Id.bigBerthaNormalId
}