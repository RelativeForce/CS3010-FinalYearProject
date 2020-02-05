module Levels.Level01 where

import Prelude
import Emo8.Types (Position)
import Data.Enemy (Enemy, defaultMarineEnemy)
import Emo8.Parse (RawMap(..))
import Data.Goal (Goal(..))
import Levels.Helper (toTilePosition, shotgunSpawn)
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
🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈯️🈯️🈯️🈯️🈯️🈯️🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈶️🈯️🈺️🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈷️🈚️🈯️🈯️🈯️🈯️🈯️🈯️🈺️🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈷️🈸️🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳
🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈷️🈚️🈚️🈸️🈳🈳🈯️🈯️🈯️🈯️🈯️🈯️🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈷️🈚️🈸️🈳🈳🈶️🈯️🈺️🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈷️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈸️🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈷️🈚️🈚️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈺️🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈷️🈚️🈯️🈺️🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳
🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈷️🈚️🈚️🈯️🈯️🈯️🈺️🈳🈳🈯️🈯️🈯️🈯️🈯️🈯️🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈶️🈯️🈺️🈳🈳🈶️🈯️🈺️🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈷️🈚️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈚️🈚️🈸️🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈷️🈚️🈚️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈺️🈳🈳🈳🈳🈷️🈚️🈸️🈳🈳🈳🈳🈳🈳🈳🈳🈷️🈚️🈸️🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈶️🈯️🈯️🈺️🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳
🈳🈳🈳🈳🈳🈷️🈸️🈳🈳🈳🈳🈳🈳🈳🈳🈷️🈚️🈚️🈯️🈯️🈯️🈯️🈯️🈯️🈺️🈳🈳🈯️🈯️🈯️🈯️🈯️🈯️🈳🈳🈳🈳🈷️🈚️🈚️🈸️🈳🈳🈶️🈯️🈺️🈳🈳🈶️🈯️🈺️🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈷️🈸️🈳🈳🈳🈳🈳🈳🈷️🈚️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈚️🈚️🈚️🈚️🈸️🈳🈳🈳🈷️🈚️🈚️🈚️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈺️🈳🈳🈳🈳🈶️🈯️🈺️🈳🈳🈳🈳🈳🈷️🈚️🈚️🈯️🈯️🈺️🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈷️🈚️🈯️🈯️🈯️🈯️🈚️🈚️🈚️🈚️🈚️🈚️🈸️🈳🈳🈳🈳🈳🈳🈷️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️
🈳🈳🈳🈷️🈚️🈯️🈺️🈳🈳🈳🈳🈳🈷️🈚️🈚️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈺️🈳🈳🈯️🈯️🈯️🈯️🈯️🈯️🈳🈷️🈚️🈚️🈯️🈯️🈯️🈺️🈳🈳🈶️🈯️🈺️🈳🈳🈶️🈯️🈺️🈳🈳🈳🈳🈳🈷️🈚️🈚️🈚️🈸️🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈷️🈸️🈳🈳🈳🈳🈳🈳🈳🈷️🈚️🈯️🈯️🈚️🈚️🈚️🈚️🈚️🈚️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈺️🈳🈳🈳🈶️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈺️🈳🈳🈳🈳🈶️🈯️🈯️🈚️🈚️🈚️🈚️🈚️🈯️🈯️🈯️🈯️🈯️🈯️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈚️🈚️🈚️🈚️🈚️🈚️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️
🈚️🈚️🈚️🈯️🈯️🈯️🈺️🈵️🈵️🈵️🈵️🈵️🈶️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈚️🈯️🈯️🈯️🈯️🈯️🈯️🈺️🈵️🈵️🈶️🈯️🈺️🈵️🈵️🈶️🈯️🈯️🈚️🈚️🈚️🈚️🈚️🈯️🈯️🈯️🈯️🈯️🈚️🈚️🈚️🈵️🈵️🈵️🈵️🈷️🈸️🈵️🈵️🈵️🈵️🈷️🈸️🈵️🈵️🈶️🈺️🈵️🈵️🈵️🈵️🈵️🈷️🈚️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈺️🈵️🈵️🈵️🈶️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈺️🈵️🈵️🈵️🈵️🈶️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️🈯️
"""

goals :: Array Goal
goals = [
    shotgunSpawn $ toTilePosition 28 7, 
    chopper, 
    ladder 0, 
    ladder 36, 
    ladder 72, 
    ladder 108, 
    ladder 144, 
    ladder 180, 
    ladder 216 
]

startPosition :: Position
startPosition = { x: 0,  y: 40 }

enemies :: Array Enemy
enemies = [
    defaultMarineEnemy 1 $ toTilePosition 26 1,
    defaultMarineEnemy 1 $ toTilePosition 27 7, 
    defaultMarineEnemy 1 $ toTilePosition 47 7,
    defaultMarineEnemy 1 $ toTilePosition 58 2,
    defaultMarineEnemy 1 $ toTilePosition 79 2,
    defaultMarineEnemy 1 $ toTilePosition 94 2,
    defaultMarineEnemy 1 $ toTilePosition 118 3,
    defaultMarineEnemy 1 $ toTilePosition 142 9,
    defaultMarineEnemy 1 $ toTilePosition 166 2 
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
ladder yOffset = NextLevel {
    pos: { 
        x: ladderX, 
        y: ladderY - yOffset
    },
    sprite: S.ladder
}

chopper :: Goal
chopper = NextLevel {
    pos: { 
        x: chopperX, 
        y: chopperY
    },
    sprite: S.chopper
}