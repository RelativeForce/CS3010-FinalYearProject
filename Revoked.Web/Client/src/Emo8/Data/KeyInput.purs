module Emo8.Data.KeyInput (KeyInput(..)) where

import Prelude

import Signal.DOM (keyPressed)

import Emo8.Class.Input (class Input)

newtype KeyInput = KeyInput { 
  isSpace :: Boolean,
  isEnter :: Boolean,
  isBackspace :: Boolean,
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

instance inputKeyInput :: Input KeyInput where
  poll = do
    spaceSig <- mkSignal Space
    enterSig <- mkSignal Enter
    backspaceSig <- mkSignal Backspace
    aSig <- mkSignal A
    bSig <- mkSignal B  
    cSig <- mkSignal C 
    dSig <- mkSignal D
    eSig <- mkSignal E 
    fSig <- mkSignal F 
    gSig <- mkSignal G 
    hSig <- mkSignal H 
    iSig <- mkSignal I 
    jSig <- mkSignal J 
    kSig <- mkSignal K 
    lSig <- mkSignal L 
    mSig <- mkSignal M 
    nSig <- mkSignal N 
    oSig <- mkSignal O 
    pSig <- mkSignal P 
    qSig <- mkSignal Q 
    rSig <- mkSignal R 
    sSig <- mkSignal S
    tSig <- mkSignal T 
    uSig <- mkSignal U  
    vSig <- mkSignal V 
    wSig <- mkSignal W
    xSig <- mkSignal X 
    ySig <- mkSignal Y 
    zSig <- mkSignal Z
    pure <<< map KeyInput $ { 
      isSpace: _,
      isEnter: _,
      isBackspace: _,
      isA: _,
      isB: _,  
      isC: _, 
      isD: _,
      isE: _, 
      isF: _, 
      isG: _, 
      isH: _, 
      isI: _, 
      isJ: _, 
      isK: _, 
      isL: _, 
      isM: _, 
      isN: _, 
      isO: _, 
      isP: _, 
      isQ: _, 
      isR: _, 
      isS: _,
      isT: _, 
      isU: _,  
      isV: _, 
      isW: _,
      isX: _, 
      isY: _, 
      isZ: _
    } 
      <$> spaceSig
      <*> enterSig
      <*> backspaceSig
      <*> aSig
      <*> bSig  
      <*> cSig 
      <*> dSig
      <*> eSig 
      <*> fSig 
      <*> gSig 
      <*> hSig 
      <*> iSig 
      <*> jSig 
      <*> kSig 
      <*> lSig 
      <*> mSig 
      <*> nSig 
      <*> oSig 
      <*> pSig 
      <*> qSig 
      <*> rSig 
      <*> sSig
      <*> tSig 
      <*> uSig  
      <*> vSig 
      <*> wSig
      <*> xSig 
      <*> ySig 
      <*> zSig
      where
        mkSignal = keyPressed <<< keyToCodeNum

data Key = 
  Space 
  | Enter
  | Backspace
  | A  
  | B    
  | C   
  | D  
  | E   
  | F   
  | G   
  | H   
  | I   
  | J   
  | K   
  | L   
  | M   
  | N   
  | O   
  | P   
  | Q   
  | R   
  | S  
  | T   
  | U    
  | V   
  | W  
  | X   
  | Y   
  | Z  

keyToCodeNum :: Key -> Int 
keyToCodeNum Space = 32
keyToCodeNum Enter = 13
keyToCodeNum Backspace = 8
keyToCodeNum A = 65
keyToCodeNum B = 66  
keyToCodeNum C = 67 
keyToCodeNum D = 68
keyToCodeNum E = 69 
keyToCodeNum F = 70 
keyToCodeNum G = 71 
keyToCodeNum H = 72 
keyToCodeNum I = 73 
keyToCodeNum J = 74 
keyToCodeNum K = 75 
keyToCodeNum L = 76 
keyToCodeNum M = 77 
keyToCodeNum N = 78 
keyToCodeNum O = 79 
keyToCodeNum P = 80 
keyToCodeNum Q = 81
keyToCodeNum R = 82 
keyToCodeNum S = 83
keyToCodeNum T = 84 
keyToCodeNum U = 85  
keyToCodeNum V = 86 
keyToCodeNum W = 87
keyToCodeNum X = 88 
keyToCodeNum Y = 89 
keyToCodeNum Z = 90
