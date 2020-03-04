module Test.Revoked.Data.Goal.MapToGun ( 
    mapToGunTests 
) where

import Prelude

import Assets.Sprites as S
import Data.Goal (Goal(..), mapToGun)
import Data.Maybe (Maybe(..))
import Data.Gun (defaultShotgunGun)
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)

mapToGunTests :: TestSuite
mapToGunTests =
    suite "Revoked.Data.Goal - mapToGun" do
        test "SHOULD be nothing WHEN goal is next level" do
            let 
                goal = nextLevel 

                expected = Nothing 

                result = mapToGun goal
            equal expected result
        test "SHOULD be nothing WHEN goal is health pack" do
            let 
                goal = healthPack 

                expected = Nothing 

                result = mapToGun goal
            equal expected result
        test "SHOULD be gun WHEN goal is gun pickup" do
            let 
                gun = defaultShotgunGun { x: 0, y: 0 } 0
                goal = GunPickup gun 

                expected = Just gun 

                result = mapToGun goal
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
