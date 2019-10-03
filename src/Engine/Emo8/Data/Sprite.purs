module Emo8.Data.Sprite where

import Prelude
import Data.Int (toNumber, floor)
import Emo8.Types (
    Sprite, 
    ScaledImage, 
    FolderPath, 
    Width, 
    Height, 
    FrameCount, 
    FramesPerSecond, 
    FileExtension
)

toScaledImage :: Sprite -> ScaledImage
toScaledImage sprite = {
    image: frameFileName sprite,
    height: sprite.height,
    width: sprite.width
}

frameFileName :: Sprite -> String
frameFileName s = s.folderPath <> "\\" <> (show $ frameIndexToCurrentFrame s) <> "." <> s.extension

incrementFrame :: Sprite -> Sprite
incrementFrame s = s { frameIndex = nextFrameIndex}
    where 
        nextFrameIndex = mod (s.frameIndex + 1) (frameLimit s)

frameLimit :: Sprite -> Int
frameLimit s = s.framesPerSecond * s.frameCount

buildSprite :: FolderPath -> Width -> Height -> FrameCount -> FramesPerSecond -> FileExtension -> Sprite
buildSprite folderPath width height frameCount fps extension = {
    folderPath: "assets\\sprites\\" <> folderPath,
    frameIndex: 0,
    framesPerSecond: fps,
    frameCount: frameCount,
    width: width,
    height: height,
    extension: extension
}

frameIndexToCurrentFrame :: Sprite -> Int
frameIndexToCurrentFrame s = floor $ (toNumber s.frameIndex) / (toNumber s.framesPerSecond)