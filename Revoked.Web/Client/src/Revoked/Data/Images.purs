module Data.Images where

import Prelude
import Emo8.Types (ScaledImage, FolderPath)

titleScreen :: ScaledImage
titleScreen = {
    image: imagesFolder <> "TitleCard.png",
    height: 720,
    width: 1280
}

blackBackground :: ScaledImage
blackBackground = {
    image: imagesFolder <> "background.png",
    height: 720,
    width: 1280
}

imagesFolder :: FolderPath
imagesFolder = "assets\\images\\"