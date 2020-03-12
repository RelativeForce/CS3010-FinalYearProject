module Test.Revoked.Data.Goal.IsNextLevelGoal ( 
    isNextLevelGoalTests 
) where

import Prelude

import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)

import Revoked.Assets.Sprites as S
import Revoked.Data.Goal (Goal(..), isNextLevelGoal)
import Revoked.Data.Gun (defaultShotgunGun)

isNextLevelGoalTests :: TestSuite
isNextLevelGoalTests =
    suite "Revoked.Data.Goal - isNextLevelGoal" do
        test "SHOULD be true WHEN goal is next level" do
            let 
                goal = nextLevel 

                expected = true 

                result = isNextLevelGoal goal
            equal expected result
        test "SHOULD be false WHEN goal is health pack" do
            let 
                goal = healthPack 

                expected = false 

                result = isNextLevelGoal goal
            equal expected result
        test "SHOULD be false WHEN goal is gun pickup" do
            let 
                goal = shotgunSpawn 

                expected = false 

                result = isNextLevelGoal goal
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