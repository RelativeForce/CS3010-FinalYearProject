module Emo8.Parse( 
  RawMap(..), 
  parseTileMap
) where

import Prelude

import Data.Array (slice)
import Data.Either (Either(..))
import Data.Foldable (length)
import Data.String (Pattern(..), Replacement(..), replace)
import Data.String.EmojiSplitter (splitEmoji)
import Data.String.Utils (lines)
import Data.Traversable (traverse)
import Emo8.Types (TileMap, ScaledImage)
import Data.Maybe (Maybe)

newtype RawMap = RawMap String

derive instance eqRawMap :: Eq RawMap
instance showRawMap :: Show RawMap where
  show (RawMap s) = "RawMap: " <> s
instance semigroupRawMap :: Semigroup RawMap where
  append (RawMap a) (RawMap b) = RawMap (a <> removeTopLF b)
    where removeTopLF = replace (Pattern "\n") (Replacement "")

type EmojiString = String
type EmojiStringArray = Array EmojiString
type EmojiStringMatrix = Array EmojiStringArray

-- | Convert raw map string to tile map
parseTileMap :: RawMap -> (String -> Maybe ScaledImage) -> Either String TileMap
parseTileMap (RawMap s) mapper = propergateError $ rawStringToSingletonArray s
  where
    propergateError :: Either String EmojiStringMatrix -> Either String TileMap
    propergateError (Left error) = Left $ error
    propergateError (Right matrix) = Right $ stringMatrixToTileMap matrix mapper

stringMatrixToTileMap :: EmojiStringMatrix -> (String -> Maybe ScaledImage) -> TileMap
stringMatrixToTileMap m mapper = (map (\line -> map mapper line) m)

rawStringToSingletonArray :: String -> Either String EmojiStringMatrix
rawStringToSingletonArray s = traverse splitEmoji rows'
  where
    rows = lines s
    rows' = slice 1 (length rows - 1) rows -- NOTE: remove "\n" top and bottom
