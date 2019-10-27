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
    image: currentFrame sprite,
    height: sprite.height,
    width: sprite.width,
    id: sprite.id
}

currentFrame :: Sprite -> String
currentFrame s = case index s.frames $ frameIndexToCurrentFrame s of
    Nothing -> ""
    Just frame -> frame

incrementFrame :: Sprite -> Sprite
incrementFrame s = s { frameIndex = nextFrameIndex }
    where 
        nextFrameIndex = mod (s.frameIndex + 1) (frameLimit s)

frameLimit :: Sprite -> Int
frameLimit s = s.framesPerSecond * s.frameCount

frameIndexToCurrentFrame :: Sprite -> Int
frameIndexToCurrentFrame s = floor $ (toNumber s.frameIndex) / (toNumber s.framesPerSecond)