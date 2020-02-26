module Emo8.Input( 
  Input, 
  InputFlags,
  mkInputSig,
  isCatchAny, 
  isReleaseAny,
  mapToCharacter
) where

import Prelude

import Emo8.Data.KeyInput (KeyInput(..))
import Emo8.Data.PressState (PressState(..), updatePressState)
import Signal (Signal, foldp)

type InputFlags = {
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

type Input = { 
  active :: InputFlags,
  catched :: InputFlags, 
  released :: InputFlags
}

-- NOTE: update after sampleOn not to miss catch and release state
type InputState = { 
  spaceState :: PressState,
  enterState :: PressState,
  backspaceState :: PressState,
  aState :: PressState,
  bState :: PressState,  
  cState :: PressState, 
  dState :: PressState,
  eState :: PressState, 
  fState :: PressState, 
  gState :: PressState, 
  hState :: PressState, 
  iState :: PressState, 
  jState :: PressState, 
  kState :: PressState, 
  lState :: PressState, 
  mState :: PressState, 
  nState :: PressState, 
  oState :: PressState, 
  pState :: PressState, 
  qState :: PressState, 
  rState :: PressState, 
  sState :: PressState,
  tState :: PressState, 
  uState :: PressState,  
  vState :: PressState, 
  wState :: PressState,
  xState :: PressState, 
  yState :: PressState, 
  zState :: PressState
}

isCatchAny :: Input -> Boolean
isCatchAny i
  = i.catched.isW || i.catched.isS || i.catched.isA || i.catched.isD
  || i.catched.isSpace || i.catched.isEnter

isReleaseAny :: Input -> Boolean
isReleaseAny i
  = i.released.isW || i.released.isS || i.released.isA || i.released.isD
  || i.released.isSpace || i.released.isEnter

mkInputSig :: Signal KeyInput -> Signal Input
mkInputSig = map mkInput <<< mkInputStateSig

mkInputStateSig :: Signal KeyInput -> Signal InputState
mkInputStateSig = foldp updateInputState initialInputState

initialInputState :: InputState
initialInputState = { 
  spaceState: Unpressed,
  enterState: Unpressed,
  backspaceState: Unpressed,
  aState : Unpressed,
  bState : Unpressed,  
  cState : Unpressed, 
  dState : Unpressed,
  eState : Unpressed, 
  fState : Unpressed, 
  gState : Unpressed, 
  hState : Unpressed, 
  iState : Unpressed, 
  jState : Unpressed, 
  kState : Unpressed, 
  lState : Unpressed, 
  mState : Unpressed, 
  nState : Unpressed, 
  oState : Unpressed, 
  pState : Unpressed, 
  qState : Unpressed, 
  rState : Unpressed, 
  sState : Unpressed,
  tState : Unpressed, 
  uState : Unpressed,  
  vState : Unpressed, 
  wState : Unpressed,
  xState : Unpressed, 
  yState : Unpressed, 
  zState : Unpressed
}

updateInputState :: KeyInput -> InputState -> InputState
updateInputState (KeyInput i) s = { 
  spaceState: updatePressState i.isSpace s.spaceState,
  enterState: updatePressState i.isEnter s.enterState,
  backspaceState: updatePressState i.isBackspace s.backspaceState,
  aState : updatePressState i.isA s.aState,
  bState : updatePressState i.isB s.bState,  
  cState : updatePressState i.isC s.cState, 
  dState : updatePressState i.isD s.dState,
  eState : updatePressState i.isE s.eState, 
  fState : updatePressState i.isF s.fState, 
  gState : updatePressState i.isG s.gState, 
  hState : updatePressState i.isH s.hState, 
  iState : updatePressState i.isI s.iState, 
  jState : updatePressState i.isJ s.jState, 
  kState : updatePressState i.isK s.kState, 
  lState : updatePressState i.isL s.lState, 
  mState : updatePressState i.isM s.mState, 
  nState : updatePressState i.isN s.nState, 
  oState : updatePressState i.isO s.oState, 
  pState : updatePressState i.isP s.pState, 
  qState : updatePressState i.isQ s.qState, 
  rState : updatePressState i.isR s.rState, 
  sState : updatePressState i.isS s.sState,
  tState : updatePressState i.isT s.tState, 
  uState : updatePressState i.isU s.uState,  
  vState : updatePressState i.isV s.vState, 
  wState : updatePressState i.isW s.wState,
  xState : updatePressState i.isX s.xState, 
  yState : updatePressState i.isY s.yState, 
  zState : updatePressState i.isZ s.zState
}

mkSubInput :: InputState -> (PressState -> Boolean) -> InputFlags
mkSubInput s f = {
  isSpace: f s.spaceState,
  isEnter: f s.enterState,
  isBackspace: f s.backspaceState,
  isA : f s.aState,
  isB : f s.bState,  
  isC : f s.cState, 
  isD : f s.dState,
  isE : f s.eState, 
  isF : f s.fState, 
  isG : f s.gState, 
  isH : f s.hState, 
  isI : f s.iState, 
  isJ : f s.jState, 
  isK : f s.kState, 
  isL : f s.lState, 
  isM : f s.mState, 
  isN : f s.nState, 
  isO : f s.oState, 
  isP : f s.pState, 
  isQ : f s.qState, 
  isR : f s.rState, 
  isS : f s.sState,
  isT : f s.tState, 
  isU : f s.uState,  
  isV : f s.vState, 
  isW : f s.wState,
  isX : f s.xState, 
  isY : f s.yState, 
  isZ : f s.zState
}

mkInput :: InputState -> Input
mkInput s = { 
  active : mkSubInput s isActive,
  catched: mkSubInput s isCatched, 
  released: mkSubInput s isReleased
}
  where
    isActive ps = ps == Catched || ps == Pressed
    isCatched ps = ps == Catched
    isReleased ps = ps == Released

mapToCharacter :: Input -> String
mapToCharacter i = 
  if i.active.isA 
    then "A" 
    else if i.active.isB 
      then "B" 
      else if i.active.isC 
        then "C" 
        else if i.active.isD 
          then "D" 
          else if i.active.isE 
            then "E" 
            else if i.active.isF 
              then "F" 
              else if i.active.isG 
                then "G" 
                else if i.active.isH 
                  then "H" 
                  else if i.active.isI 
                    then "I" 
                    else if i.active.isJ 
                      then "J" 
                      else if i.active.isK 
                        then "K" 
                        else if i.active.isL 
                          then "L" 
                          else if i.active.isM
                            then "M" 
                            else if i.active.isN 
                              then "N" 
                              else if i.active.isO
                                then "O" 
                                else if i.active.isP 
                                  then "P" 
                                  else if i.active.isQ 
                                    then "Q" 
                                    else if i.active.isR 
                                      then "R" 
                                      else if i.active.isS 
                                        then "S" 
                                        else if i.active.isT 
                                          then "T" 
                                          else if i.active.isU 
                                            then "U" 
                                            else if i.active.isV 
                                              then "V" 
                                              else if i.active.isW
                                                then "W" 
                                                else if i.active.isX 
                                                  then "X" 
                                                  else if i.active.isY 
                                                    then "Y" 
                                                    else if i.active.isZ 
                                                      then "Z" 
                                                      else ""