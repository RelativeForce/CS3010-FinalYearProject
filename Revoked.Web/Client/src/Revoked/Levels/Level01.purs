module Levels.Level01 where

import Prelude
import Data.Enemy (Enemy, defaultMarine)
import Emo8.Parse (RawMap(..))
import Data.Goal (Goal(..))
import Assets.Sprites as S

mapData :: RawMap
mapData = RawMap """
🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳
🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳
🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳
🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳
🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳
🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳
🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈷️🈚️🈸️🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳
🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈷️🈚️🈯️🈯️🈺️🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳
🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈚️🈚️🈚️🈚️🈚️🈚️🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈷️🈚️🈸️🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈷️🈚️🈯️🈯️🈯️🈯️🈺️🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳
🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈯️🈯️🈯️🈯️🈯️🈯️🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈶️🈯️🈺️🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈷️🈚️🈯️🈯️🈯️🈯️🈯️🈯️🈺️🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳
🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈷️🈚️🈚️🈸️🈳🈳🈯️🈯️🈯️🈯️🈯️🈯️🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈷️🈚️🈸️🈳🈳🈶️🈯️🈺️🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈷️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈸️🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈷️🈚️🈚️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈺️🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳
🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈷️🈚️🈚️🈯️🈯️🈯️🈺️🈳🈳🈯️🈯️🈯️🈯️🈯️🈯️🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈶️🈯️🈺️🈳🈳🈶️🈯️🈺️🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈷️🈚️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈚️🈚️🈸️🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈷️🈚️🈚️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈺️🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳
🈳🈳🈳🈳🈳🈷️🈸️🈳🈳🈳🈳🈳🈳🈳🈳🈷️🈚️🈚️🈯️🈯️🈯️🈯️🈯️🈯️🈺️🈳🈳🈯️🈯️🈯️🈯️🈯️🈯️🈳🈳🈳🈳🈷️🈚️🈚️🈸️🈳🈳🈶️🈯️🈺️🈳🈳🈶️🈯️🈺️🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈷️🈸️🈳🈳🈳🈳🈳🈳🈷️🈚️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈚️🈚️🈚️🈚️🈸️🈳🈳🈳🈷️🈚️🈚️🈚️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈺️🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈷️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️
🈳🈳🈳🈷️🈚️🈯️🈺️🈳🈳🈳🈳🈳🈷️🈚️🈚️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈺️🈳🈳🈯️🈯️🈯️🈯️🈯️🈯️🈳🈷️🈚️🈚️🈯️🈯️🈯️🈺️🈳🈳🈶️🈯️🈺️🈳🈳🈶️🈯️🈺️🈳🈳🈳🈳🈳🈷️🈚️🈚️🈚️🈸️🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈷️🈸️🈳🈳🈳🈳🈳🈳🈳🈷️🈚️🈯️🈯️🈚️🈚️🈚️🈚️🈚️🈚️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈺️🈳🈳🈳🈶️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️
🈚️🈚️🈚️🈯️🈯️🈯️🈺️🈵️🈵️🈵️🈵️🈵️🈶️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈯️🈯️🈯️🈯️🈯️🈯️🈺️🈵️🈵️🈶️🈯️🈺️🈵️🈵️🈶️🈯️🈯️🈚️🈚️🈚️🈚️🈚️🈯️🈯️🈯️🈯️🈯️🈚️🈚️🈚️🈵️🈵️🈵️🈵️🈷️🈸️🈵️🈵️🈵️🈵️🈷️🈸️🈵️🈵️🈶️🈺️🈵️🈵️🈵️🈵️🈵️🈷️🈚️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈺️🈵️🈵️🈵️🈶️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️
"""

goals :: Array Goal
goals = [ 
    chopper, 
    ladder 0, 
    ladder 36, 
    ladder 72, 
    ladder 108, 
    ladder 144, 
    ladder 180, 
    ladder 216 
]

enemies :: Array Enemy
enemies = [
    defaultMarine { x: 830, y: 32 },
    defaultMarine { x: 864, y: 224 }, 
    defaultMarine { x: 1830, y: 150 },
    defaultMarine { x: 1980, y: 250 }
]

chopperY :: Int
chopperY = 400

chopperX :: Int
chopperX = 6200

ladderY :: Int
ladderY = chopperY - 35

ladderX :: Int
ladderX = chopperX + 150

ladder :: Int -> Goal
ladder yOffset = Goal {
    pos: { 
        x: ladderX, 
        y: ladderY - yOffset
    },
    sprite: S.ladder
}

chopper :: Goal
chopper = Goal {
    pos: { 
        x: chopperX, 
        y: chopperY
    },
    sprite: S.chopper
}