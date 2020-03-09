module Test.Revoked.Data.Helper.IsDead ( 
    isDeadTests 
) where

import Prelude

import Emo8.Class.Object (class Object)
import Revoked.Class.MortalEntity (class MortalEntity)
import Data.Helper (isDead)
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)

isDeadTests :: TestSuite
isDeadTests =
    suite "Revoked.Data.Helper - isDead" do
        test "SHOULD be alive WHEN health is above 0" do
            let 
                health = 1

                expected = false 

                result = isDead $ Test health
            equal expected result
        test "SHOULD be dead WHEN health is zero" do
            let 
                health = 0

                expected = true 

                result = isDead $ Test health
            equal expected result
        test "SHOULD be dead WHEN health is below zero" do
            let 
                health = -1

                expected = true 

                result = isDead $ Test health
            equal expected result

data FakeMortalEntity = Test Int

instance objectEnemy :: Object FakeMortalEntity where
    size (Test s) = { width: 0, height: 0 }
    position (Test s) = { x: 0, y: 0 }
    scroll offset (Test s) = Test $ s 

instance mortalEntityPlayer :: MortalEntity FakeMortalEntity where
    health (Test m) = m
    damage (Test m) healthLoss = Test $ m - healthLoss 
    heal (Test m) healthBonus = Test $ m + healthBonus 