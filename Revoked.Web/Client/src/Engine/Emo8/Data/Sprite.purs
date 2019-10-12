module Emo8.Data.Sprite where

import Prelude
import Data.Array (index)
import Data.Maybe (Maybe(..))
import Data.Int (toNumber, floor)
import Emo8.Types (
    Sprite, 
    ScaledImage
)

toScaledImage :: Sprite -> ScaledImage
toScaledImage sprite = {
    image: frameFileName sprite,
    height: sprite.height,
    width: sprite.width
}

frameFileName :: Sprite -> String
frameFileName s = case index s.frames $ frameIndexToCurrentFrame s of
    Nothing -> ""
    Just frame -> frame

incrementFrame :: Sprite -> Sprite
incrementFrame s = s { frameIndex = nextFrameIndex}
    where 
        nextFrameIndex = mod (s.frameIndex + 1) (frameLimit s)

frameLimit :: Sprite -> Int
frameLimit s = s.framesPerSecond * s.frameCount

frameIndexToCurrentFrame :: Sprite -> Int
frameIndexToCurrentFrame s = floor $ (toNumber s.frameIndex) / (toNumber s.framesPerSecond)