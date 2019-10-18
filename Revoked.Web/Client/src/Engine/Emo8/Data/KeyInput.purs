module Emo8.Data.KeyInput
  ( KeyInput(..)
  ) where

import Prelude

import Emo8.Class.Input (class Input)
import Signal.DOM (keyPressed)

newtype KeyInput = KeyInput { 
  isLeft :: Boolean, 
  isRight :: Boolean, 
  isUp :: Boolean, 
  isDown :: Boolean, 
  isW :: Boolean, 
  isA :: Boolean, 
  isS :: Boolean, 
  isD :: Boolean,
  isSpace :: Boolean,
  isEnter :: Boolean
}

instance inputKeyInput :: Input KeyInput where
  poll = do
    leftSig <- mkSignal Left
    rightSig <- mkSignal Right
    upSig <- mkSignal Up
    downSig <- mkSignal Down
    wSig <- mkSignal W
    aSig <- mkSignal A
    sSig <- mkSignal S
    dSig <- mkSignal D
    spaceSig <- mkSignal Space
    enterSig <- mkSignal Enter
    pure <<< map KeyInput $ { 
      isLeft: _, 
      isRight: _, 
      isUp: _, 
      isDown: _, 
      isW: _, 
      isA: _, 
      isS: _, 
      isD: _,
      isSpace: _,
      isEnter: _
    } 
      <$> leftSig
      <*> rightSig
      <*> upSig
      <*> downSig
      <*> wSig
      <*> aSig
      <*> sSig
      <*> dSig
      <*> spaceSig
      <*> enterSig
      where
        mkSignal = keyPressed <<< keyToCodeNum

data Key
  = Left | Right | Up | Down
  | W | A | S | D | Space | Enter

keyToCodeNum :: Key -> Int 
keyToCodeNum Left = 37
keyToCodeNum Right = 39
keyToCodeNum Up = 38
keyToCodeNum Down = 40
keyToCodeNum W = 87
keyToCodeNum A = 65
keyToCodeNum S = 83
keyToCodeNum D = 68
keyToCodeNum Space = 32
keyToCodeNum Enter = 13
