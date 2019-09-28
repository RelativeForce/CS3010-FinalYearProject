module Emo8.Data.Image where

import Prelude

newtype Image = Image String
    
type ScaledImage = {
    image :: Image,
    width :: Number,
    height :: Number
}

titleScreen :: ScaledImage
titleScreen = {
    image: Image "TitleCard.png",
    height: 720.0,
    width: 1280.0
}