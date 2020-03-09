module Revoked.Assets.AssetMapper where

import Data.Maybe (Maybe(..))

import Emo8.Types (ScaledImage)

import Revoked.Assets.Images as I

emojiToImage :: String -> Maybe ScaledImage
emojiToImage s = case s of
    "🈚️" -> Just I.grassTop
    "🈷️" -> Just I.grassLeftCorner
    "🈸️" -> Just I.grassRightCorner
    "🈶️" -> Just I.grassLeft
    "🈺️" -> Just I.grassRight
    "🈵️" -> Just I.toxicWaste
    "🈯️" -> Just I.grassCenter
    "🈳" -> Nothing
    _ -> Nothing