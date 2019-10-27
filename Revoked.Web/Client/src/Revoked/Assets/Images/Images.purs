module Assets.Images where

import Emo8.Types (ScaledImage)
import Assets.AssetIds as Id
import Assets.Images.TitleScreen (titleScreenData)
import Assets.Images.BlackBackground (blackBackgroundData)
import Assets.Images.GrassTopData (grassTopDataData)

titleScreen :: ScaledImage
titleScreen = {
    image: titleScreenData,
    height: 720,
    width: 1280,
    id: Id.titleScreenId
}

blackBackground :: ScaledImage
blackBackground = {
    image: blackBackgroundData,
    height: 720,
    width: 1280,
    id: Id.blackBackgroundId
}

grassTop :: ScaledImage
grassTop = {
    image: grassTopDataData,
    height: 128,
    width: 128,
    id: Id.grassTopId
}