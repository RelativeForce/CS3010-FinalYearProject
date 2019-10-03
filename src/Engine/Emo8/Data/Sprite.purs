module Emo8.Data.Sprite where

import Prelude
import Emo8.Types (Sprite, ScaledImage)
import Data.Int (toNumber, floor)

toScaledImage :: Sprite -> ScaledImage
toScaledImage sprite = {
    image: frameFileName sprite,
    height: sprite.height,
    width: sprite.width
}

frameFileName :: Sprite -> String
frameFileName s = s.folderPath <> "\\" <> (show $ frameIndexToCurrentFrame s) <> "." <> s.extension

incrementFrame :: Sprite -> Sprite
incrementFrame s = s { frameIndex = nextFrameIndex}
    where 
        nextFrameIndex = mod (s.frameIndex + 1) (frameLimit s)

frameLimit :: Sprite -> Int
frameLimit s = s.framesPerSecond * s.frameCount

frameIndexToCurrentFrame :: Sprite -> Int
frameIndexToCurrentFrame s = floor $ (toNumber s.frameIndex) / (toNumber s.framesPerSecond)