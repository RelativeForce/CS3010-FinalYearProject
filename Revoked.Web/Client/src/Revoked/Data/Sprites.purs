module Data.Sprites where

import Prelude
import Emo8.Types (
    Sprite,  
    FolderPath, 
    Width, 
    Height, 
    FrameCount, 
    FramesPerSecond, 
    FileExtension
)

player :: Sprite
player = buildSprite "player" 32 32 1 1 "png"

buildSprite :: FolderPath -> Width -> Height -> FrameCount -> FramesPerSecond -> FileExtension -> Sprite
buildSprite folderPath width height frameCount fps extension = {
    folderPath: spritesFolder <> folderPath,
    frameIndex: 0,
    framesPerSecond: fps,
    frameCount: frameCount,
    width: width,
    height: height,
    extension: extension
}

spritesFolder :: FolderPath
spritesFolder = "assets\\sprites\\"