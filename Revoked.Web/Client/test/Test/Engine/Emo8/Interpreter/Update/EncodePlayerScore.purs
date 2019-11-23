module Test.Emo8.Interpreter.Update.EncodePlayerScore ( 
    encodePlayerScoreTests 
) where

import Emo8.Interpreter.Update (encodePlayerScore)
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)

encodePlayerScoreTests :: TestSuite
encodePlayerScoreTests =
    suite "Revoked.Data.HighScores - encodePlayerScore" do
        test "shouldStringifyCorrectlyWithValidData" do
            let 
                score = {
                    username: "test username",
                    score: 5,
                    start: "test start",
                    end: "test end"
                }
                expectedJson = "{\"username\":\"test username\",\"start\":\"test start\",\"score\":5,\"end\":\"test end\"}"

                result = encodePlayerScore score
            equal expectedJson result