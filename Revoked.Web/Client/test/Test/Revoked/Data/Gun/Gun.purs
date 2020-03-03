module Test.Revoked.Data.Gun ( 
    gunTests 
) where
import Test.Revoked.Data.Gun.Pistol (pistolTests)
import Test.Unit (TestSuite)

gunTests :: TestSuite
gunTests = do
    pistolTests