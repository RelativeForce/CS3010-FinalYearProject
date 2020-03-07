module Test.Revoked.Data.Goal.ToHealthBonus ( 
    toHealthBonusTests 
) where

import Prelude

import Assets.Sprites as S
import Data.Goal (Goal(..), toHealthBonus)
import Constants (healthPackBonusHealth)
import Data.Gun (defaultShotgunGun)
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)

toHealthBonusTests :: TestSuite
toHealthBonusTests =
    suite "Revoked.Data.Goal - toHealthBonus" do
        test "SHOULD be healthPackBonus WHEN goal array contains a health pack" do
            let 
                goals = [ 
                    nextLevel,
                    shotgunSpawn,
                    healthPack,
                    shotgunSpawn,
                    nextLevel
                ]

                expected = healthPackBonusHealth

                result = toHealthBonus goals
            equal expected result
        test "SHOULD be zero WHEN goal array contains no health packs" do
            let 
                goals = [ 
                    nextLevel,
                    shotgunSpawn,
                    shotgunSpawn,
                    nextLevel
                ]

                expected = 0

                result = toHealthBonus goals
            equal expected result
        test "SHOULD be healthPackBonus x 3 WHEN goal array contains 3 health packs" do
            let 
                goals = [ 
                    nextLevel,
                    healthPack,
                    shotgunSpawn,
                    healthPack,
                    healthPack,
                    shotgunSpawn,
                    nextLevel
                ]

                expected = healthPackBonusHealth * 3

                result = toHealthBonus goals
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