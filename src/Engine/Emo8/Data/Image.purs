module Emo8.Data.Image where

import Prelude

import Data.Maybe (Maybe(..))
import Graphics.Canvas (CanvasImageSource, tryLoadImage)
import Effect (Effect)
import Effect.Exception (throwException, error)

newtype Image = Image String

instance showImage :: Show Image where
    show (Image s) = s
  
derive instance eqImage :: Eq Image

loadImage :: String -> (CanvasImageSource -> Effect Unit) -> Effect Unit
loadImage imagePath f = tryLoadImage imagePath $ \maybeImageSource -> 
    case maybeImageSource of
        Just imageSource -> f imageSource
        Nothing -> throwException $ error ("Panic! Could not load image from path: " <> (show imagePath))
    