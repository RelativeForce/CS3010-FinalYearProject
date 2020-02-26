module Assets.Sprites.BigBerthaImmune.Sprite where

import Emo8.Types (Sprite)
import Assets.Sprites.BigBerthaImmune.Frame0 (frame0Data)
import Assets.Sprites.BigBerthaImmune.Frame1 (frame1Data)
import Assets.AssetIds as Id

bigBerthaImmune :: Sprite
bigBerthaImmune = {
    frames: [frame0Data, frame1Data],
    frameIndex: 0,
    framesPerSecond: 2,
    frameCount: 2,
    size: {
        width: 134,
        height: 50
    },
    id: Id.bigBerthaImmuneId
}