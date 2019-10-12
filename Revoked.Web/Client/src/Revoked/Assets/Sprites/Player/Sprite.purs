module Assets.Sprites.Player.Sprite where

import Emo8.Types (Sprite)
import Assets.Sprites.Player.Frame0 (frame0Data)

player ::  Sprite
player = {
    frames: [frame0Data],
    frameIndex: 0,
    framesPerSecond: 1,
    frameCount: 1,
    width: 32,
    height: 32
}