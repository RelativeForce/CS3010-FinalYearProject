module Emo8.Data.Sprite where

import Prelude

import Data.Array (index)
import Data.Maybe (Maybe(..))
import Data.Int (toNumber, floor)

import Emo8.Types (Sprite, ScaledImage)

-- | Converts a `Sprite` into a `ScaledImage`
toScaledImage :: Sprite -> ScaledImage
toScaledImage sprite = {
    image: currentFrame sprite,
    size: sprite.size,
    id: sprite.id
}

-- | Retrieves the current frame of a `Sprite`
currentFrame :: Sprite -> String
currentFrame s = case index s.frames $ frameIndexToCurrentFrame s of
    Nothing -> ""
    Just frame -> frame

-- | Incremenets a `Sprite` to its next frame
incrementFrame :: Sprite -> Sprite
incrementFrame s = s { frameIndex = nextFrameIndex }
    where 
        nextFrameIndex = mod (s.frameIndex + 1) (frameLimit s)

-- | Whether the `Sprite` is currently on its last frame
isLastFrame :: Sprite -> Boolean
isLastFrame s = (s.frameIndex + 1) == frameLimit s

-- | The maximum frame index for a given `Sprite`
frameLimit :: Sprite -> Int
frameLimit s = s.framesPerSecond * s.frameCount

-- | The frame index of the current frame of a given `Sprite`
frameIndexToCurrentFrame :: Sprite -> Int
frameIndexToCurrentFrame s = floor $ (toNumber s.frameIndex) / (toNumber s.framesPerSecond)