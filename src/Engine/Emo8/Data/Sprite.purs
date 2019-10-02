module Emo8.Data.Sprite where

import Prelude
import Emo8.Types (Sprite, ScaledImage)
import Math (remainder)
import Data.Int (toNumber, floor)

toScaledImage :: Sprite -> ScaledImage
toScaledImage sprite = {
    image: frameFileName sprite,
    height: sprite.height,
    width: sprite.width
}

frameFileName :: Sprite -> String
frameFileName s = s.frameFolder <> "\\" <> (show s.currentFrame) <> "." <> s.extension

incrementFrame :: Sprite -> Sprite
incrementFrame s = s { currentFrame = floor $ remainder (toNumber (s.currentFrame + 1)) (toNumber s.frameCount)}