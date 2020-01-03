module Test.Engine.Emo8.Utils.Angle ( 
    angleTests 
) where

import Prelude
import Emo8.Utils (angle)
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)

angleTests :: TestSuite
angleTests =
    suite "Emo8.Utils - angle" do
        test "assert angle = 45 when x = 5,  y = 5" do
            let 
                vector = { x: 5, y: 5 }

                expectedAngle = 45

                result = mod (angle vector) 360
            equal expectedAngle result
        test "assert angle = 315  when x = 5,  y = -5"  do
            let 
                vector = { x: 5, y: -5 }

                expectedAngle = 315

                result = mod (angle vector) 360
            equal expectedAngle result
        test "assert angle = 0   when x = 0,  y = 0"  do
            let 
                vector = { x: 0, y: 0 }

                expectedAngle = 0

                result = mod (angle vector) 360
            equal expectedAngle result
        test "assert angle = 0   when x = 5,  y = 0"  do
            let 
                vector = { x: 5, y: 0 }

                expectedAngle = 0

                result = mod (angle vector) 360
            equal expectedAngle result
        test "assert angle = 180 when x = -5, y = 0"  do
            let 
                vector = { x: -5, y: 0 }

                expectedAngle = 180

                result = mod (angle vector) 360
            equal expectedAngle result
        test "assert angle = 90 when x = 0,  y = 5"  do
            let 
                vector = { x: 0, y: 5 }

                expectedAngle = 90

                result = mod (angle vector) 360
            equal expectedAngle result
        test "assert angle = 270  when x = 0,  y = -5"  do
            let 
                vector = { x: 0, y: -5 }

                expectedAngle = 270

                result = mod (angle vector) 360
            equal expectedAngle result
        test "assert angle = 329  when x = 5,  y = -3"  do
            let 
                vector = { x: 5, y: -3 }

                expectedAngle = 329

                result = mod (angle vector) 360
            equal expectedAngle result
        test "assert angle = 30 when x = 5,  y = 3"  do
            let 
                vector = { x: 5, y: 3 }

                expectedAngle = 30

                result = mod (angle vector) 360
            equal expectedAngle result
        test "assert angle = 149 when x = -5, y = 3"  do
            let 
                vector = { x: -5, y: 3 }

                expectedAngle = 149

                result = mod (angle vector) 360
            equal expectedAngle result
        test "assert angle = 210 when x = -5, y = -3"  do
            let 
                vector = { x: -5, y: -3 }

                expectedAngle = 210

                result = mod (angle vector) 360
            equal expectedAngle result
        test "assert angle = 59 when x = 3,  y = 5"  do
            let 
                vector = { x: 3, y: 5 }

                expectedAngle = 59

                result = mod (angle vector) 360
            equal expectedAngle result
        test "assert angle = 300  when x = 3,  y = -5"  do
            let 
                vector = { x: 3, y: -5 }

                expectedAngle = 300

                result = mod (angle vector) 360
            equal expectedAngle result
        test "assert angle = 120 when x = -3, y = 5"  do
            let 
                vector = { x: -3, y: 5 }

                expectedAngle = 120

                result = mod (angle vector) 360
            equal expectedAngle result
        test "assert angle = 239 when x = -3, y = -5"  do
            let 
                vector = { x: -3, y: -5 }

                expectedAngle = 239

                result = mod (angle vector) 360
            equal expectedAngle result
        test "assert angle = 121 when x = -78, y = 128"  do
            let 
                vector = { x: -78, y: 128 }

                expectedAngle = 121

                result = angle vector
            equal expectedAngle result