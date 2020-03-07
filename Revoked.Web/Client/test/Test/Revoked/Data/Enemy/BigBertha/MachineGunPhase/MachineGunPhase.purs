module Test.Revoked.Data.Enemy.BigBertha.MachineGunPhase ( 
    machineGunPhaseTests 
) where

import Prelude

import Test.Revoked.Data.Enemy.BigBertha.MachineGunPhase.DefaultMachineGunPhase (defaultMachineGunPhaseTests)
import Test.Revoked.Data.Enemy.BigBertha.MachineGunPhase.UpdateMachineGunPhase (updateMachineGunPhaseTests)
import Test.Unit (TestSuite)

machineGunPhaseTests :: TestSuite
machineGunPhaseTests = do
    defaultMachineGunPhaseTests
    updateMachineGunPhaseTests
    