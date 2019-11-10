module Assets.Images where

import Emo8.Types (ScaledImage)
import Assets.AssetIds as Id
import Assets.Images.TitleScreen (titleScreenData)
import Assets.Images.BlackBackground (blackBackgroundData)
import Assets.Images.ToxicWaste (toxicWasteData)
import Assets.Images.GrassTop (grassTopData)
import Assets.Images.GrassLeftCorner (grassLeftCornerData)
import Assets.Images.GrassRight (grassRightData)
import Assets.Images.GrassCenter (grassCenterData)
import Assets.Images.GameOverScreen (gameOverScreenData)

titleScreen :: ScaledImage
titleScreen = {
    image: titleScreenData,
    size: {
        height: 720,
        width: 1280
    },    
    id: Id.titleScreenId
}

gameOverScreen :: ScaledImage
gameOverScreen = {
    image: gameOverScreenData,
    size: {
        height: 720,
        width: 1280
    },    
    id: Id.gameOverScreenId
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

grassLeftCorner :: ScaledImage
grassLeftCorner = {
    image: grassLeftCornerData,
    size: {
        height: 32,
        width: 32
    },
    id: Id.grassLeftCornerId
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

toxicWaste :: ScaledImage
toxicWaste = {
    image: toxicWasteData,
    size: {
        height: 32,
        width: 32
    },
    id: Id.toxicWasteId
}