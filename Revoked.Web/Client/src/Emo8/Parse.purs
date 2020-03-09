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
import Data.Maybe (Maybe)

import Emo8.Types (TileMap, ScaledImage)

-- | The in code representation of a map. This can be converted into a `TileMap` 
-- | using `parseTileMap`.
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

-- | Convert `RawMap` string to `TileMap` with the given function that maps and Emoji 
-- | into `Maybe ScaledImage`
parseTileMap :: (String -> Maybe ScaledImage) -> RawMap -> Either String TileMap
parseTileMap mapper (RawMap s) = propergateError $ toEmojiStringMatrix s
  where
    propergateError :: Either String EmojiStringMatrix -> Either String TileMap
    propergateError (Left error) = Left $ error
    propergateError (Right matrix) = Right $ stringMatrixToTileMap matrix mapper

-- | Maps each cell in the `EmojiStringMatrix` into a `Maybe ScaledImage` using the 
-- | given mapping function.
stringMatrixToTileMap :: EmojiStringMatrix -> (String -> Maybe ScaledImage) -> TileMap
stringMatrixToTileMap m mapper = (map (\line -> map mapper line) m)

-- | Parses a string of Emojis into an EmojiString Matrix or a error message if it fails. This 
-- | ignores the first and line and splits lines at the "\n" character
toEmojiStringMatrix :: String -> Either String EmojiStringMatrix
toEmojiStringMatrix s = traverse splitEmoji rows'
  where
    rows = lines s
    rows' = slice 1 (length rows - 1) rows -- Ignore top and bottom lines
