module Levels.Level01 where

import Prelude
import Emo8.Types (Position)
import Data.Enemy (Enemy, defaultMarineEnemy)
import Emo8.Parse (RawMap(..))
import Data.Goal (Goal(..))
import Data.Gun (defaultShotgunGun)
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
    shotgunSpawn { x: 900, y: 224 }, 
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
    defaultMarineEnemy { x: 830, y: 32 },
    defaultMarineEnemy { x: 864, y: 224 }, 
    defaultMarineEnemy { x: 1504, y: 224 },
    defaultMarineEnemy { x: 1856, y: 64 },
    defaultMarineEnemy { x: 2528, y: 64 },
    defaultMarineEnemy { x: 3008, y: 64 },
    defaultMarineEnemy { x: 5312, y: 64 }
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

shotgunSpawn :: Position -> Goal
shotgunSpawn pos = GunPickup $ defaultShotgunGun pos 0