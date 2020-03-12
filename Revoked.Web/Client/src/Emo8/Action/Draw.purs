module Emo8.Action.Draw where

import Prelude

import Control.Monad.Free (Free, liftF)

import Emo8.Data.Color (Color)
import Emo8.Types (Deg, MapId, X, Y, Image, ScaledImage, Sprite, Size, TextHeight)

-- | The monad for representing drawing operations which can be interpreted into
-- | non-pure operations.
type Draw = Free DrawF

-- | The data type that defines the ajoint functors that represent the non-pure operations 
-- | required to draw text, images and sprites on screen. A function is required to 
-- | interpret these operations into draw operations which can be defined on a per 
-- | output basis.
data DrawF n = 
    DrawImageNoScaling Image X Y n
    | DrawScaledImage ScaledImage X Y n
    | DrawRotatedScaledImage ScaledImage X Y Deg n
    | DrawSprite Sprite X Y n
    | DrawRotatedSprite Sprite X Y Deg n
    | DrawText String TextHeight X Y Color n
    | DrawMap MapId Size X Y n

-- | Draws a image with no scaling at a given position
-- | Arguments
-- | - `Image`: data-URI OR path to image
-- | - `X`: horizontal displacement in pixels from the origin
-- | - `Y`: vertical displacement in pixels from the origin
-- | Returns
-- | - `Draw Unit`: a simple draw action to be interpreted.
drawImageNoScaling :: Image -> X -> Y -> Draw Unit
drawImageNoScaling image x y = liftF $ DrawImageNoScaling image x y unit

-- | Draws a scaled image at a given position
-- | Arguments
-- | - `ScaledImage`: image to be drawn
-- | - `X`: horizontal displacement in pixels from the origin
-- | - `Y`: vertical displacement in pixels from the origin
-- | Returns
-- | - `Draw Unit`: a simple draw action to be interpreted.
drawScaledImage :: ScaledImage -> X -> Y -> Draw Unit
drawScaledImage image x y = liftF $ DrawScaledImage image x y unit

-- | Draws a scaled image with at a given position with a given rotation
-- | Arguments
-- | - `ScaledImage`: image to be drawn
-- | - `X`: horizontal displacement in pixels from the origin
-- | - `Y`: vertical displacement in pixels from the origin
-- | - `Deg`: angle from positive horizontal axis (right)
-- | Returns
-- | - `Draw Unit`: a simple draw action to be interpreted.
drawRotatedScaledImage :: ScaledImage -> X -> Y -> Deg -> Draw Unit
drawRotatedScaledImage image x y angle = liftF $ DrawRotatedScaledImage image x y angle unit

-- | Draws the current frame sprite at a given position
-- | Arguments
-- | - `Sprite`: [Sprite](types.md\#Sprite) to be drawn
-- | - `X`: horizontal displacement in pixels from the origin
-- | - `Y`: vertical displacement in pixels from the origin
-- | Returns
-- | - `Draw Unit`: a simple draw action to be interpreted.
drawSprite :: Sprite -> X -> Y -> Draw Unit
drawSprite sprite x y = liftF $ DrawSprite sprite x y unit

-- | Draws the current frame sprite at a given position with a given rotation
-- | Arguments
-- | - `Sprite`: [Sprite](types.md\#Sprite) to be drawn
-- | - `X`: horizontal displacement in pixels from the origin
-- | - `Y`: vertical displacement in pixels from the origin
-- | - `Deg`: angle from positive horizontal axis (right)
-- | Returns
-- | - `Draw Unit`: a simple draw action to be interpreted.
drawRotatedSprite :: Sprite -> X -> Y -> Deg -> Draw Unit
drawRotatedSprite sprite x y angle = liftF $ DrawRotatedSprite sprite x y angle unit

-- | Draws text at a given position with a given colour and height
-- | Arguments
-- | - `String`: text to be drawn
-- | - `TextHeight`: see [TextHeight](types.md\#TextHeight)
-- | - `X`: horizontal displacement in pixels from the origin
-- | - `Y`: vertical displacement in pixels from the origin
-- | - `Color`: hex-code color of the text
-- | Returns
-- | - `Draw Unit`: a simple draw action to be interpreted.
drawText :: String -> TextHeight -> X -> Y -> Color -> Draw Unit
drawText text height x y color = liftF $ DrawText text height x y color unit

-- | Draws the region of the map with the specified Id that is visible when a region of the
-- | default monitor size is at the specifed position.
-- | Arguments
-- | - `MapId`: the id of the map to be drawn
-- | - `Size`: the size of the map
-- |- `X`: horizontal displacement in pixels from the origin
-- | - `Y`: vertical displacement in pixels from the origin
-- | Returns
-- | - `Draw Unit`: a simple draw action to be interpreted.
drawMap :: MapId -> Size -> X -> Y -> Draw Unit
drawMap mapId size x y = liftF $ DrawMap mapId size x y unit
