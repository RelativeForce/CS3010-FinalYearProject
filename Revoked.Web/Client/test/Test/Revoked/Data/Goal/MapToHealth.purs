module Test.Revoked.Data.Goal.MapToHealth ( 
    mapToHealthTests 
) where

import Prelude

import Revoked.Assets.Sprites as S
import Revoked.Constants (healthPackBonusHealth)
import Revoked.Data.Goal (Goal(..), mapToHealth)
import Data.Gun (defaultShotgunGun)
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)

mapToHealthTests :: TestSuite
mapToHealthTests =
    suite "Revoked.Data.Goal - mapToHealth" do
        test "SHOULD be zero WHEN goal is next level" do
            let 
                goal = nextLevel 

                expected = 0 

                result = mapToHealth goal
            equal expected result
        test "SHOULD be health pack bonus WHEN goal is health pack" do
            let 
                goal = healthPack 

                expected = healthPackBonusHealth 

                result = mapToHealth goal
            equal expected result
        test "SHOULD be zero WHEN goal is gun pickup" do
            let 
                goal = shotgunSpawn 

                expected = 0 

                result = mapToHealth goal
            equal expected result

nextLevel :: Goal
nextLevel = NextLevel {
    pos: { x: 0, y: 0 },
    sprite: S.ladder
}

healthPack :: Goal
healthPack = HealthPack {
    pos: { x: 0, y: 0 },
    sprite: S.healthPack
}

shotgunSpawn :: Goal
shotgunSpawn = GunPickup $ defaultShotgunGun { x: 0, y: 0 } 0