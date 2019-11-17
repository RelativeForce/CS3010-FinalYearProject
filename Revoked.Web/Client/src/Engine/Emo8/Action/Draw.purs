module Emo8.Action.Draw where

import Prelude

import Control.Monad.Free (Free, liftF)
import Emo8.Data.Color (Color)
import Emo8.Data.Emoji (Emoji)
import Emo8.Types (Deg, MapId, X, Y, Image, ScaledImage, Sprite, Size, TextHeight)

type Draw = Free DrawF

data DrawF n
    = ClearScreen Color n
    | DrawImageNoScaling Image X Y n
    | DrawScaledImage ScaledImage X Y n
    | DrawRotatedScaledImage ScaledImage X Y Deg n
    | DrawSprite Sprite X Y n
    | DrawRotatedSprite Sprite X Y Deg n
    | DrawText String TextHeight X Y Color n
    | Emo Appearance Emoji Size X Y n
    | Emor Appearance Deg Emoji Size X Y n
    | DrawMap MapId Size X Y n

data Appearance = Normal | Mirrored

-- | Clear screen with given color.
cls :: Color -> Draw Unit
cls c = liftF $ ClearScreen c unit

drawImageNoScaling :: Image -> X -> Y -> Draw Unit
drawImageNoScaling image x y = liftF $ DrawImageNoScaling image x y unit

drawScaledImage :: ScaledImage -> X -> Y -> Draw Unit
drawScaledImage image x y = liftF $ DrawScaledImage image x y unit

drawRotatedScaledImage :: ScaledImage -> X -> Y -> Deg -> Draw Unit
drawRotatedScaledImage image x y angle = liftF $ DrawRotatedScaledImage image x y angle unit

drawSprite :: Sprite -> X -> Y -> Draw Unit
drawSprite sprite x y = liftF $ DrawSprite sprite x y unit

drawRotatedSprite :: Sprite -> X -> Y -> Deg -> Draw Unit
drawRotatedSprite sprite x y angle = liftF $ DrawRotatedSprite sprite x y angle unit

drawText :: String -> TextHeight -> X -> Y -> Color -> Draw Unit
drawText text height x y color = liftF $ DrawText text height x y color unit

-- | Draw emoji.
emo :: Emoji -> Size -> X -> Y -> Draw Unit
emo e size x y = liftF $ Emo Normal e size x y unit

-- | Draw rotated emoji.
emo' :: Emoji -> Size -> X -> Y -> Draw Unit
emo' e size x y = liftF $ Emo Mirrored e size x y unit

-- | Draw mirrored emoji.
emor :: Deg -> Emoji -> Size -> X -> Y -> Draw Unit
emor deg e size x y = liftF $ Emor Normal deg e size x y unit

-- | Draw mirrored rotated emoji.
emor' :: Deg -> Emoji -> Size -> X -> Y -> Draw Unit
emor' deg e size x y = liftF $ Emor Mirrored deg e size x y unit

-- | Draw tile map.
drawMap :: MapId -> Size -> X -> Y -> Draw Unit
drawMap mId size x y = liftF $ DrawMap mId size x y unit
