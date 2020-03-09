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

type RenderOp = DrawContext -> Effect Unit

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
    interpret (DrawMap mId size x y n) = const n <$> drawMap mId size x y dctx

withLocalDraw :: RenderOp -> RenderOp
withLocalDraw op dctx = do
    save dctx.ctx
    op dctx
    restore dctx.ctx

drawText :: String -> TextHeight -> X -> Y -> Color -> RenderOp
drawText e size x y color =
    withLocalDraw \dctx -> do
        let 
            font = joinWith " " [show size <> "px", fontFamily]
            y' = toBaseY dctx.monitorSize y

        setFont dctx.ctx font
        setTextBaseline dctx.ctx BaselineIdeographic
        setFillStyle dctx.ctx (colorToCode color)
        fillText dctx.ctx e (toNumber x) (toNumber y')             

drawMap :: MapId -> Size -> X -> Y -> RenderOp
drawMap = drawMapWithF drawScaledImage

drawMapWithF :: (ScaledImage -> X -> Y -> RenderOp) -> MapId -> Size -> X -> Y -> RenderOp
drawMapWithF f mId size x y =
    withLocalDraw \dctx -> do

        let map = case dctx.mapData !! mId of
                Nothing -> []
                Just m -> m

        for_ (emapWithIndex map) \(Tuple vertId withIdRow) ->
            for_ withIdRow \(Tuple horiId maybeImage) ->
                when ((isVisible dctx.monitorSize horiId vertId) && (notEmpty maybeImage))
                    let xx = x + (size.width * horiId)
                        yy = y + (size.height * vertId) 
                        img = case maybeImage of
                            Nothing -> { image: "", size: { height: 0, width: 0 }, id: 0 }
                            Just i -> i
                    in f img xx yy dctx
    where
        withIndex :: forall a. Array a -> Array (Tuple Int a)
        withIndex arr = zip (0..((length arr) - 1)) arr
        -- NOTE: reverse for y axis
        withIndexRev :: forall a. Array a -> Array (Tuple Int a)
        withIndexRev arr = zip (((length arr) - 1)..0) arr
        emapWithIndex = withIndexRev <<< (map withIndex)

        notEmpty :: Maybe ScaledImage -> Boolean
        notEmpty maybeImage = case maybeImage of
            Nothing -> false
            Just img -> true

        isVisible :: MonitorSize -> X -> Y -> Boolean
        isVisible ms xId yId =
            ( xId >= xlBoundId
            && xId <= xrBoundId ms
            && yId >= ybBoundId
            && yId <= ytBoundId ms
            )
        maxMapElemX ms = ms.width / size.width
        maxMapElemY ms = ms.height / size.height
        xMapId = x / size.width
        yMapId = y / size.height
        xlBoundId = - (xMapId + 1)
        xrBoundId ms = xlBoundId + maxMapElemX ms
        ybBoundId = - (yMapId + 1)
        ytBoundId ms = ybBoundId + maxMapElemY ms


toBaseY :: MonitorSize -> Y -> Y
toBaseY ms y = ms.height - y

degToRad :: Deg -> Number
degToRad d = 2.0 * pi * toNumber d / 360.0

drawImageNoScaling :: Image -> X -> Y -> RenderOp
drawImageNoScaling image x y =
            withLocalDraw \dctx ->
                let y' = toBaseY dctx.monitorSize y   
                in loadImage image $ \src -> drawImage dctx.ctx src (toNumber x) (toNumber y')                   

drawScaledImage :: ScaledImage -> X -> Y -> RenderOp
drawScaledImage scaledImage x y =
            withLocalDraw \dctx ->
                let 
                    size = scaledImage.size
                    y' = offsetY dctx.monitorSize size.height y   
                in loadImage scaledImage.image $ \src -> drawImageScale dctx.ctx src (toNumber x) (toNumber y') (toNumber size.width) (toNumber size.height)              

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

drawSprite :: Sprite -> X -> Y -> RenderOp
drawSprite sprite x y = drawScaledImage (toScaledImage sprite) x y

drawRotatedSprite :: Sprite -> X -> Y -> Deg -> RenderOp
drawRotatedSprite sprite x y angle = drawRotatedScaledImage (toScaledImage sprite) x y angle

loadImage :: String -> (CanvasImageSource -> Effect Unit) -> Effect Unit
loadImage imagePath f = tryLoadImage imagePath $ \maybeImageSource -> 
    case maybeImageSource of
        Just imageSource -> f imageSource
        Nothing -> throwException $ error ("Error - Could not load image from path: " <> (show imagePath))

offsetY :: MonitorSize -> Height -> Y -> Y
offsetY monitorSize height y = monitorSize.height - (y + height)