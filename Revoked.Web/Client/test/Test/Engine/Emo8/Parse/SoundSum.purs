module Test.Engine.Emo8.Parse.SoundSum( 
    soundSumTests
) where

import Prelude

import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)
import Emo8.Parse (RawSound(..))

soundSumTests :: TestSuite
soundSumTests =
    suite "Engine.Emo8.Parse - soundSum" do
        test "shouldConcatinateTwoSounds" do
            equal soundSum $ soundA <> soundB

soundA :: RawSound
soundA = RawSound """
🎼🔈4️⃣🎹🎹🎹🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳
"""

soundB :: RawSound
soundB = RawSound """
🎼🔈4️⃣🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🎹🎹🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳
"""

soundSum :: RawSound
soundSum = RawSound """
🎼🔈4️⃣🎹🎹🎹🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳
🎼🔈4️⃣🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳🎹🎹🈳🈳🈳🈳🈳🈳🈳🈳🈳🈳
"""