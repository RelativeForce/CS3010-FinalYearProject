module Assets.Sprites.Chopper.Sprite where

import Emo8.Types (Sprite)
import Assets.Sprites.Chopper.Frame0 (frame0Data)
import Assets.Sprites.Chopper.Frame1 (frame1Data)
import Assets.Sprites.Chopper.Frame2 (frame2Data)
import Assets.Sprites.Chopper.Frame3 (frame3Data)
import Assets.AssetIds as Id

chopper ::  Sprite
chopper = {
    frames: [frame0Data, frame1Data, frame2Data, frame3Data],
    frameIndex: 0,
    framesPerSecond: 2,
    frameCount: 4,
    size: {
        width: 258,
        height: 64
    },
    id: Id.chopperId
}