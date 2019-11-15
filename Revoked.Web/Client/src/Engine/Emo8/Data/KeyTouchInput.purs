module Emo8.Data.KeyTouchInput ( 
  KeyTouchInput(..), 
  anyKeyTouch
) where

import Prelude

import Emo8.Class.Input (class Input, poll)
import Emo8.Data.KeyInput (KeyInput(..))
import Emo8.Data.TouchInput (TouchInput(..))

newtype KeyTouchInput = KeyTouchInput { 
  isLeft :: Boolean, 
  isRight :: Boolean, 
  isUp :: Boolean, 
  isDown :: Boolean, 
  isSpace :: Boolean,
  isEnter :: Boolean,
  isA :: Boolean,
  isB :: Boolean,  
  isC :: Boolean, 
  isD :: Boolean,
  isE :: Boolean, 
  isF :: Boolean, 
  isG :: Boolean, 
  isH :: Boolean, 
  isI :: Boolean, 
  isJ :: Boolean, 
  isK :: Boolean, 
  isL :: Boolean, 
  isM :: Boolean, 
  isN :: Boolean, 
  isO :: Boolean, 
  isP :: Boolean, 
  isQ :: Boolean, 
  isR :: Boolean, 
  isS :: Boolean,
  isT :: Boolean, 
  isU :: Boolean,  
  isV :: Boolean, 
  isW :: Boolean,
  isX :: Boolean, 
  isY :: Boolean, 
  isZ :: Boolean
}

instance inputKeyTouchInput :: Input KeyTouchInput where
  poll = do
    keyInputSig <- poll
    touchInputSig <- poll
    pure $ mergeInput <$> keyInputSig <*> touchInputSig

mergeInput :: KeyInput -> TouchInput -> KeyTouchInput
mergeInput (KeyInput k) (TouchInput t) = KeyTouchInput { 
  isLeft: k.isLeft || t.isLeft, 
  isRight: k.isRight || t.isRight, 
  isUp: k.isUp || t.isUp, 
  isDown: k.isDown || t.isDown, 
  isSpace: k.isSpace,
  isEnter: k.isEnter,
  isA: k.isA,
  isB: k.isB,  
  isC: k.isC, 
  isD: k.isD,
  isE: k.isE, 
  isF: k.isF, 
  isG: k.isG, 
  isH: k.isH, 
  isI: k.isI, 
  isJ: k.isJ, 
  isK: k.isK, 
  isL: k.isL, 
  isM: k.isM, 
  isN: k.isN, 
  isO: k.isO, 
  isP: k.isP, 
  isQ: k.isQ, 
  isR: k.isR, 
  isS: k.isS,
  isT: k.isT, 
  isU: k.isU,  
  isV: k.isV, 
  isW: k.isW,
  isX: k.isX, 
  isY: k.isY, 
  isZ: k.isZ
}

anyKeyTouch :: KeyTouchInput -> Boolean
anyKeyTouch (KeyTouchInput i) = 
  i.isUp 
  || i.isDown 
  || i.isLeft 
  || i.isRight 
  || i.isSpace 
  || i.isEnter
  || i.isA
  || i.isB  
  || i.isC 
  || i.isD
  || i.isE 
  || i.isF 
  || i.isG 
  || i.isH 
  || i.isI 
  || i.isJ 
  || i.isK 
  || i.isL 
  || i.isM 
  || i.isN 
  || i.isO 
  || i.isP 
  || i.isQ 
  || i.isR 
  || i.isS
  || i.isT 
  || i.isU  
  || i.isV 
  || i.isW
  || i.isX 
  || i.isY 
  || i.isZ
