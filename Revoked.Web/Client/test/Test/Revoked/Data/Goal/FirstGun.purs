module Test.Revoked.Data.Goal.FirstGun ( 
    firstGunTests 
) where

import Prelude

import Revoked.Assets.Sprites as S
import Revoked.Data.Goal (Goal(..), firstGun)
import Revoked.Data.Gun (defaultBlasterGun, defaultShotgunGun, defaultAssaultRifleGun)
import Data.Maybe (Maybe(..))
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)

firstGunTests :: TestSuite
firstGunTests =
    suite "Revoked.Data.Goal - firstGun" do
        test "SHOULD be gun WHEN goal array conatins 1 gun" do
            let 
                gun = defaultShotgunGun { x: 0, y: 0 } 0
                gunPickup = GunPickup gun 

                goals = [
                    gunPickup
                ] 

                expected = Just gun 

                result = firstGun goals
            equal expected result
        test "SHOULD be nothing WHEN goal array conatins no gun" do
            let 
                goals = [
                    nextLevel,
                    healthPack
                ] 

                expected = Nothing

                result = firstGun goals
            equal expected result
        test "SHOULD be first gun WHEN goal array conatins multiple guns" do
            let 
                gun1 = defaultShotgunGun { x: 0, y: 0 } 0
                gunPickup1 = GunPickup gun1 
                gun2 = defaultBlasterGun { x: 0, y: 0 } 0
                gunPickup2 = GunPickup gun2 
                gun3 = defaultAssaultRifleGun { x: 0, y: 0 } 0
                gunPickup3 = GunPickup gun3 

                goals = [
                    gunPickup1,
                    gunPickup2,
                    gunPickup3
                ] 

                expected = Just gun1

                result = firstGun goals
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