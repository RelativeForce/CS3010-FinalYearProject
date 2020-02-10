module Assets.Images where

import Emo8.Types (ScaledImage)
import Assets.AssetIds as Id
import Assets.Images.TitleScreen (titleScreenData)
import Assets.Images.PlayBackground (playBackgroundData)
import Assets.Images.ToxicWaste (toxicWasteData)
import Assets.Images.GrassTop (grassTopData)
import Assets.Images.GrassLeftCorner (grassLeftCornerData)
import Assets.Images.GrassRightCorner (grassRightCornerData)
import Assets.Images.GrassLeft (grassLeftData)
import Assets.Images.GrassRight (grassRightData)
import Assets.Images.GrassCenter (grassCenterData)
import Assets.Images.GameOverScreen (gameOverScreenData)
import Assets.Images.VictoryScreen (victoryScreenData)
import Assets.Images.LeaderboardScreen (leaderboardScreenData)
import Assets.Images.InstructionsScreen (instructionsScreenData)
import Assets.Images.Heart (heartData)

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

victoryScreen :: ScaledImage
victoryScreen = {
    image: victoryScreenData,
    size: {
        height: 720,
        width: 1280
    },    
    id: Id.victoryScreenId
}

leaderboardScreen :: ScaledImage
leaderboardScreen = {
    image: leaderboardScreenData,
    size: {
        height: 720,
        width: 1280
    },    
    id: Id.leaderboardScreenId
}

playBackground :: ScaledImage
playBackground = {
    image: playBackgroundData,
    size: {
        height: 720,
        width: 1280
    },
    id: Id.playBackgroundId
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

grassRightCorner :: ScaledImage
grassRightCorner = {
    image: grassRightCornerData,
    size: {
        height: 32,
        width: 32
    },
    id: Id.grassRightCornerId
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

toxicWaste :: ScaledImage
toxicWaste = {
    image: toxicWasteData,
    size: {
        height: 32,
        width: 32
    },
    id: Id.toxicWasteId
}

heart :: ScaledImage
heart = {
    image: heartData,
    size: {
        height: 20,
        width: 20
    },
    id: Id.heartId
}

instructionsScreen :: ScaledImage
instructionsScreen = {
    image: instructionsScreenData,
    size: {
        height: 720,
        width: 1280
    },    
    id: Id.instructionsScreenId
}