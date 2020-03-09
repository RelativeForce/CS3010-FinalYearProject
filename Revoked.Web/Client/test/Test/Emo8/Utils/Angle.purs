module Test.Engine.Emo8.Utils.Angle ( 
    angleTests 
) where

import Prelude

import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)

import Emo8.Utils (angle)

angleTests :: TestSuite
angleTests =
    suite "Engine.Emo8.Utils - angle" do
        test "ASSERT angle = 45 WHEN x = 5, y = 5" do
            let 
                vector = { x: 5, y: 5 }

                expectedAngle = 45

                result = mod (angle vector) 360
            equal expectedAngle result
        test "ASSERT angle = 315 WHEN x = 5, y = -5"  do
            let 
                vector = { x: 5, y: -5 }

                expectedAngle = 315

                result = mod (angle vector) 360
            equal expectedAngle result
        test "ASSERT angle = 0 WHEN x = 0, y = 0"  do
            let 
                vector = { x: 0, y: 0 }

                expectedAngle = 0

                result = mod (angle vector) 360
            equal expectedAngle result
        test "ASSERT angle = 0 WHEN x = 5, y = 0"  do
            let 
                vector = { x: 5, y: 0 }

                expectedAngle = 0

                result = mod (angle vector) 360
            equal expectedAngle result
        test "ASSERT angle = 180 WHEN x = -5, y = 0"  do
            let 
                vector = { x: -5, y: 0 }

                expectedAngle = 180

                result = mod (angle vector) 360
            equal expectedAngle result
        test "ASSERT angle = 90 WHEN x = 0, y = 5"  do
            let 
                vector = { x: 0, y: 5 }

                expectedAngle = 90

                result = mod (angle vector) 360
            equal expectedAngle result
        test "ASSERT angle = 270 WHEN x = 0, y = -5"  do
            let 
                vector = { x: 0, y: -5 }

                expectedAngle = 270

                result = mod (angle vector) 360
            equal expectedAngle result
        test "ASSERT angle = 329 WHEN x = 5, y = -3"  do
            let 
                vector = { x: 5, y: -3 }

                expectedAngle = 329

                result = mod (angle vector) 360
            equal expectedAngle result
        test "ASSERT angle = 30 WHEN x = 5, y = 3"  do
            let 
                vector = { x: 5, y: 3 }

                expectedAngle = 30

                result = mod (angle vector) 360
            equal expectedAngle result
        test "ASSERT angle = 149 WHEN x = -5, y = 3"  do
            let 
                vector = { x: -5, y: 3 }

                expectedAngle = 149

                result = mod (angle vector) 360
            equal expectedAngle result
        test "ASSERT angle = 210 WHEN x = -5, y = -3"  do
            let 
                vector = { x: -5, y: -3 }

                expectedAngle = 210

                result = mod (angle vector) 360
            equal expectedAngle result
        test "ASSERT angle = 59 WHEN x = 3, y = 5"  do
            let 
                vector = { x: 3, y: 5 }

                expectedAngle = 59

                result = mod (angle vector) 360
            equal expectedAngle result
        test "ASSERT angle = 300 WHEN x = 3, y = -5"  do
            let 
                vector = { x: 3, y: -5 }

                expectedAngle = 300

                result = mod (angle vector) 360
            equal expectedAngle result
        test "ASSERT angle = 120 WHEN x = -3, y = 5"  do
            let 
                vector = { x: -3, y: 5 }

                expectedAngle = 120

                result = mod (angle vector) 360
            equal expectedAngle result
        test "ASSERT angle = 239 WHEN x = -3, y = -5"  do
            let 
                vector = { x: -3, y: -5 }

                expectedAngle = 239

                result = mod (angle vector) 360
            equal expectedAngle result
        test "ASSERT angle = 121 WHEN x = -78, y = 128"  do
            let 
                vector = { x: -78, y: 128 }

                expectedAngle = 121

                result = angle vector
            equal expectedAngle result