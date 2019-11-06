module Assets.Images where

import Emo8.Types (ScaledImage)
import Assets.AssetIds as Id
import Assets.Images.TitleScreen (titleScreenData)
import Assets.Images.BlackBackground (blackBackgroundData)
import Assets.Images.GrassTopData (grassTopData)
import Assets.Images.GrassLeftData (grassLeftData)
import Assets.Images.GrassRightData (grassRightData)
import Assets.Images.GrassCenterData (grassCenterData)

titleScreen :: ScaledImage
titleScreen = {
    image: titleScreenData,
    size: {
        height: 720,
        width: 1280
    },    
    id: Id.titleScreenId
}

blackBackground :: ScaledImage
blackBackground = {
    image: blackBackgroundData,
    size: {
        height: 720,
        width: 1280
    },
    id: Id.blackBackgroundId
}

grassTop :: ScaledImage
grassTop = {
    image: grassTopData,
    size: {
        height: 32,
        width: 32
    },
    id: Id.grassTopId
}

grassLeft :: ScaledImage
grassLeft = {
    image: grassLeftData,
    size: {
        height: 32,
        width: 32
    },
    id: Id.grassLeftId
}

grassRight :: ScaledImage
grassRight = {
    image: grassRightData,
    size: {
        height: 32,
        width: 32
    },
    id: Id.grassRightId
}

grassCenter :: ScaledImage
grassCenter = {
    image: grassCenterData,
    size: {
        height: 32,
        width: 32
    },
    id: Id.grassCenterId
}