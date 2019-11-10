module Assets.AssetMapper where
  
import Assets.Images as I
import Data.Maybe (Maybe(..))
import Emo8.Types (ScaledImage)

emojiToImage :: String -> Maybe ScaledImage
emojiToImage s = case s of
    "🈷️" -> Just I.grassLeftCorner
    "🈚️" -> Just I.grassTop
    "🈸️" -> Just I.grassRightCorner
    "🈵️" -> Just I.toxicWaste
    "🈯️" -> Just I.grassCenter
    "🈳" -> Nothing
    _ -> Nothing