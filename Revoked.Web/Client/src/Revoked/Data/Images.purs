module Data.Images where

import Emo8.Types (ScaledImage)
import Assets.Images.TitleScreen (titleScreenData)
import Assets.Images.BlackBackground (blackBackgroundData)

titleScreen :: ScaledImage
titleScreen = {
    image: titleScreenData,
    height: 720,
    width: 1280
}

blackBackground :: ScaledImage
blackBackground = {
    image: blackBackgroundData,
    height: 720,
    width: 1280
}