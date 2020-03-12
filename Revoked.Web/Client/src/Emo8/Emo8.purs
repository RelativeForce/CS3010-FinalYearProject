module Emo8( emo8, buildAsset ) where

import Prelude

import Data.Int (toNumber)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Exception (throw)
import Graphics.Canvas (CanvasElement, getCanvasElementById, getContext2D, setCanvasHeight, setCanvasWidth)
import Signal (runSignal, sampleOn)
import Signal.DOM (animationFrame)
import Signal.Effect (foldEffect)
import Data.Traversable (traverse)

import Emo8.Excepiton (orErrMsg)
import Emo8.Parse (RawMap, parseTileMap)
import Emo8.Class.Game (class Game, draw, update)
import Emo8.Class.Input (poll)
import Emo8.Constants (canvasId)
import Emo8.Input (toInputSignal)
import Emo8.Interpreter.Draw (runDraw)
import Emo8.Interpreter.Update (runUpdate)
import Emo8.Types (Asset, MonitorSize, ScaledImage)

-- | Run game function.
emo8 :: forall s. Game s => s -> Asset -> MonitorSize -> Effect Unit
emo8 state asset ms =
  -- Perfrom the main game loop with the canvas 
  withCanvas $ mainLoop state asset ms

-- | The main game render/update loop
mainLoop :: forall s. Game s => s -> Asset -> MonitorSize -> CanvasElement -> Effect Unit
mainLoop state asset ms canvas = do

  -- Set up canvas and poll input
  setCanvasDimensions canvas ms
  context <- getContext2D canvas
  frameSig <- animationFrame
  keyTouchInputSig <- poll

  -- Parse input and build draw context
  let
    drawContext = { ctx: context, mapData: asset.mapData, monitorSize: ms } 
    inputSignal = toInputSignal $ sampleOn frameSig keyTouchInputSig

  -- Update game state
  stateSignal <- foldEffect (\input -> runUpdate <<< (update asset input)) state inputSignal 

  -- Draw updated game state
  runSignal $ map (\s -> (runDraw drawContext <<< draw) s) stateSignal

-- | Runs a given operation with the graphics canvas if that canvas exists
withCanvas :: (CanvasElement -> Effect Unit) -> Effect Unit
withCanvas operation = do
  maybeCanvas <- getCanvasElementById canvasId

  -- If the canvas exists, run given operation, otherwise, throw error.
  case maybeCanvas of
    Just canvas -> operation canvas
    Nothing -> throw $ "canvas id: " <> canvasId <> " was not found."

-- | Sets the canvas dimensions
setCanvasDimensions :: CanvasElement -> MonitorSize -> Effect Unit
setCanvasDimensions canvas ms = do
  setCanvasWidth canvas $ toNumber ms.width
  setCanvasHeight canvas $ toNumber ms.height
  
-- | Build asset data from raw maps using a given emoji mapping function. If there are 
-- | unparsable strings, exception raised when executing javascript.
buildAsset :: Array RawMap -> (String -> Maybe ScaledImage) -> Effect Asset
buildAsset rawMaps mapper = do
    ms <- orErrMsg $ traverse (parseTileMap mapper) rawMaps 
    pure { mapData: ms }
