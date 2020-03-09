module Test.Revoked.Data.Goal.IsGunGoal ( 
    isGunGoalTests 
) where

import Prelude

import Revoked.Assets.Sprites as S
import Revoked.Data.Goal (Goal(..), isGunGoal)
import Revoked.Data.Gun (defaultShotgunGun)
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)

isGunGoalTests :: TestSuite
isGunGoalTests =
    suite "Revoked.Data.Goal - isGunGoal" do
        test "SHOULD be false WHEN goal is next level" do
            let 
                goal = nextLevel 

                expected = false 

                result = isGunGoal goal
            equal expected result
        test "SHOULD be false WHEN goal is health pack" do
            let 
                goal = healthPack 

                expected = false 

                result = isGunGoal goal
            equal expected result
        test "SHOULD be true WHEN goal is gun pickup" do
            let 
                goal = shotgunSpawn 

                expected = true 

                result = isGunGoal goal
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