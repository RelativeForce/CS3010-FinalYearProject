module Emo8.Interpreter.Draw where

import Prelude

import Control.Monad.Free (foldFree)
import Data.Array (length, zip, (..), (!!))
import Data.Int (toNumber)
import Data.Maybe (Maybe(..))
import Data.String (joinWith)
import Data.Traversable (for_)
import Data.Tuple (Tuple(..))
import Effect (Effect)
import Effect.Exception (throwException, error)
import Graphics.Canvas (CanvasImageSource, fillText, restore, rotate, save, setFillStyle, setFont, translate, drawImage, tryLoadImage, drawImageScale)
import Math (pi)

import Emo8.Action.Draw (Draw, DrawF(..))
import Emo8.Constants (fontFamily)
import Emo8.Data.Color (Color, colorToCode)
import Emo8.FFI.TextBaseline (TextBaseline(..), setTextBaseline)
import Emo8.Types (Deg, MapId, MonitorSize, Size, X, Y, DrawContext, Image, ScaledImage, Sprite, Height, TextHeight)
import Emo8.Data.Sprite (toScaledImage)

-- | A drawing operation on a canvas with a given DrawContext
type RenderOp = DrawContext -> Effect Unit

-- | Interprets a `Draw` into an `Effect` where all of the `DrawF` functors perform various operations on the 
-- | given drawing context.
runDraw :: forall a. DrawContext -> Draw a -> Effect a
runDraw dctx = foldFree interpret
  where
    interpret :: DrawF ~> Effect
    interpret (DrawImageNoScaling image x y n) = const n <$> drawImageNoScaling image x y dctx
    interpret (DrawScaledImage image x y n) = const n <$> drawScaledImage image x y dctx
    interpret (DrawRotatedScaledImage image x y angle n) = const n <$> drawRotatedScaledImage image x y angle dctx
    interpret (DrawSprite sprite x y n) = const n <$> drawSprite sprite x y dctx
    interpret (DrawRotatedSprite sprite x y angle n) = const n <$> drawRotatedSprite sprite x y angle dctx
    interpret (DrawText text height x y color n) = const n <$> drawText text height x y color dctx
    interpret (DrawMap mapId size x y n) = const n <$> drawMap mapId size x y dctx

-- | Performs a `RenderOp` within a local drawing context such that the context 
-- | before the operation can be restored.
withLocalDraw :: RenderOp -> RenderOp
withLocalDraw op dctx = do
    save dctx.ctx
    op dctx
    restore dctx.ctx

-- | Draws text with given `TextHeight`, `Position` and `Color`
drawText :: String -> TextHeight -> X -> Y -> Color -> RenderOp
drawText text size x y color =
    withLocalDraw \dctx -> do
        let 
            font = joinWith " " [show size <> "px", fontFamily]
            y' = toBaseY dctx.monitorSize y

        -- Set up the context for drawing the text
        setFont dctx.ctx font
        setTextBaseline dctx.ctx BaselineIdeographic
        setFillStyle dctx.ctx (colorToCode color)

        -- Draw the text
        fillText dctx.ctx text (toNumber x) (toNumber y')             

-- | Draws the map with the specified `MapId` based on the size of the tile 
-- | and position of the map
drawMap :: MapId -> Size -> X -> Y -> RenderOp
drawMap mapId size x y =
    withLocalDraw \dctx -> do

        -- Get the map
        let map = case dctx.mapData !! mapId of
                Nothing -> []
                Just m -> m

        -- Iterate over each cell in the map
        for_ (mapWithIndex map) \(Tuple vertId withIdRow) ->
            for_ withIdRow \(Tuple horiId maybeImage) ->

                -- Draw the visible and non empty cells
                when ((isVisible dctx.monitorSize horiId vertId) && (notEmpty maybeImage))
                    let xx = x + (size.width * horiId)
                        yy = y + (size.height * vertId) 
                        img = case maybeImage of
                            Nothing -> { image: "", size: { height: 0, width: 0 }, id: 0 }
                            Just i -> i
                    in drawScaledImage img xx yy dctx
    where
        -- Convert map to map with each row and coloum index where the y index 
        -- has reversed indexes as the screen origin is top left.
        mapWithIndex = withIndexReversed <<< (map withIndex)

        -- | Whether or not a cell in the map contains a tile
        notEmpty :: Maybe ScaledImage -> Boolean
        notEmpty maybeImage = case maybeImage of
            Nothing -> false
            Just img -> true

        -- | Whether or not a given cell in the map is visible 
        isVisible :: MonitorSize -> X -> Y -> Boolean
        isVisible ms xId yId = ( 
            xId >= xlBoundId && 
            xId <= xrBoundId ms && 
            yId >= ybBoundId && 
            yId <= ytBoundId ms
        )

        maxMapElemX ms = ms.width / size.width
        maxMapElemY ms = ms.height / size.height
        xMapId = x / size.width
        yMapId = y / size.height
        xlBoundId = - (xMapId + 1)
        xrBoundId ms = xlBoundId + maxMapElemX ms
        ybBoundId = - (yMapId + 1)
        ytBoundId ms = ybBoundId + maxMapElemY ms

-- | Draws a given image at a specified position
drawImageNoScaling :: Image -> X -> Y -> RenderOp
drawImageNoScaling image x y =
            withLocalDraw \dctx ->
                let y' = toBaseY dctx.monitorSize y   
                in loadImage image $ \src -> drawImage dctx.ctx src (toNumber x) (toNumber y')                   

-- | Draws a given scaled image at a specified position
drawScaledImage :: ScaledImage -> X -> Y -> RenderOp
drawScaledImage scaledImage x y =
            withLocalDraw \dctx ->
                let 
                    size = scaledImage.size
                    y' = offsetY dctx.monitorSize size.height y   
                in loadImage scaledImage.image $ \src -> drawImageScale dctx.ctx src (toNumber x) (toNumber y') (toNumber size.width) (toNumber size.height)              

-- | Draws a given scaled image at a specified position and rotation
drawRotatedScaledImage :: ScaledImage -> X -> Y -> Deg -> RenderOp
drawRotatedScaledImage scaledImage x y angle =
            withLocalDraw \dctx ->
                let y' = offsetY dctx.monitorSize scaledImage.size.height y     
                in loadImage scaledImage.image $ \src -> 
                    do
                        translate dctx.ctx { translateX: toNumber x, translateY: toNumber y' }
                        rotate dctx.ctx (-degToRad angle)
                        drawImageScale dctx.ctx src 0.0 0.0 (toNumber scaledImage.size.width) (toNumber scaledImage.size.height)
                        rotate dctx.ctx (degToRad angle)
                        translate dctx.ctx { translateX: -toNumber x, translateY: -toNumber y' }                                           

-- | Draws a given `Sprite` at a specified position
drawSprite :: Sprite -> X -> Y -> RenderOp
drawSprite sprite x y = drawScaledImage (toScaledImage sprite) x y

-- | Draws a given `Sprite` at a specified position and rotation
drawRotatedSprite :: Sprite -> X -> Y -> Deg -> RenderOp
drawRotatedSprite sprite x y angle = drawRotatedScaledImage (toScaledImage sprite) x y angle

-- | Loads an image with a given path or data uri and performs an specified operation
loadImage :: String -> (CanvasImageSource -> Effect Unit) -> Effect Unit
loadImage imagePath f = tryLoadImage imagePath $ \maybeImageSource -> 
    case maybeImageSource of
        Just imageSource -> f imageSource
        Nothing -> throwException $ error ("Error - Could not load image from path: " <> (show imagePath))

-- | Convert a given `Y` to the screen Y as the screen's origin is top left.
toBaseY :: MonitorSize -> Y -> Y
toBaseY ms y = ms.height - y

-- | Convert from degrees to Radians
degToRad :: Deg -> Number
degToRad d = 2.0 * pi * toNumber d / 360.0

-- | Determine a the `Y` coordinate for an object with a given `Height` such that the 
-- | bottom left of the object is its origin. This is done as the for the java canvas 
-- | an image's origin is the top left. 
offsetY :: MonitorSize -> Height -> Y -> Y
offsetY monitorSize height y = monitorSize.height - (y + height)

-- | Maps an array to an array of tuples where the first member of the tuple is that 
-- | elements index.
withIndex :: forall a. Array a -> Array (Tuple Int a)
withIndex arr = zip (0 .. ((length arr) - 1)) arr

-- | Maps an array to an array of tuples where the first member of the tuple is that 
-- | elements index if the array had been reversed.
withIndexReversed :: forall a. Array a -> Array (Tuple Int a)
withIndexReversed arr = zip (((length arr) - 1) .. 0) arr