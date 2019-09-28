module Emo8.Action.Draw where

import Prelude

import Control.Monad.Free (Free, liftF)
import Control.Monad.Gen (Size)
import Emo8.Data.Color (Color)
import Emo8.Data.Emoji (Emoji)
import Emo8.Types (Deg, MapId, X, Y, Image, ScaledImage)

type Draw = Free DrawF

data DrawF n
    = ClearScreen Color n
    | DrawImageNoScaling Image X Y n
    | DrawScaledImage ScaledImage X Y n
    | DrawRotatedScaledImage ScaledImage X Y Deg n
    | Emo Appearance Emoji Size X Y n
    | Emor Appearance Deg Emoji Size X Y n
    | Emap Appearance MapId Size X Y n

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

-- | Draw emoji map.
emap :: MapId -> Size -> X -> Y -> Draw Unit
emap mId size x y = liftF $ Emap Normal mId size x y unit

-- | Draw mirrored emoji map.
emap' :: MapId -> Size -> X -> Y -> Draw Unit
emap' mId size x y = liftF $ Emap Mirrored mId size x y unit
