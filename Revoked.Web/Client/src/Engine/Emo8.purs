module Emo8( emo8 ) where

import Prelude

import Data.Int (toNumber)
import Data.Maybe (Maybe(..))
import Data.String (joinWith)
import Effect (Effect)
import Effect.Exception (throw)
import Emo8.Class.Game (class Game, draw, update)
import Emo8.Class.Input (poll)
import Emo8.Constants (canvasId)
import Emo8.Input (mkInputSig)
import Emo8.Interpreter.Draw (runDraw)
import Emo8.Interpreter.Update (runUpdate)
import Emo8.Types (Asset, MonitorSize)
import Emo8.Utils (mkAsset)
import Graphics.Canvas (CanvasElement, getCanvasElementById, getContext2D, setCanvasHeight, setCanvasWidth)
import Signal (runSignal, sampleOn)
import Signal.DOM (animationFrame)
import Signal.Effect (foldEffect)

-- | Run game function.
emo8 :: forall s. Game s => s -> Asset -> MonitorSize -> Effect Unit
emo8 state asset ms = withCanvas \canvas -> do
  setDim canvas ms
  context <- getContext2D canvas
  bootAsset <- mkAsset []
  let drawCtx = { ctx: context, mapData: asset.mapData, monitorSize: ms }
      bootDrawCtx = { ctx: context, mapData: bootAsset.mapData, monitorSize: ms }

  frameSig <- animationFrame
  keyTouchInputSig <- poll
  let keyTouchInputSampleSig = sampleOn frameSig keyTouchInputSig
      inputSampleSig = mkInputSig keyTouchInputSampleSig
  stateSig <- foldEffect (\i -> runUpdate <<< (update asset i)) state inputSampleSig 
  runSignal $ map (\s -> (runDraw drawCtx <<< draw) s) stateSig

withCanvas :: (CanvasElement -> Effect Unit) -> Effect Unit
withCanvas op = do
  mCanvas <- getCanvasElementById canvasId
  case mCanvas of
    Just c -> op c
    Nothing -> throw $ joinWith " " ["canvas id:", canvasId, "was not found."]

setDim :: CanvasElement -> MonitorSize -> Effect Unit
setDim canvas ms = do
  setCanvasWidth canvas $ toNumber ms.width
  setCanvasHeight canvas $ toNumber ms.height
