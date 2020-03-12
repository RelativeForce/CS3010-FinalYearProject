module Test.Revoked.Data.Enemy.BigBertha.MachineGunPhase ( 
    machineGunPhaseTests 
) where

import Prelude

import Test.Unit (TestSuite)

import Test.Revoked.Data.Enemy.BigBertha.MachineGunPhase.DefaultMachineGunPhase (defaultMachineGunPhaseTests)
import Test.Revoked.Data.Enemy.BigBertha.MachineGunPhase.UpdateMachineGunPhase (updateMachineGunPhaseTests)

machineGunPhaseTests :: TestSuite
machineGunPhaseTests = do
    defaultMachineGunPhaseTests
    updateMachineGunPhaseTests
    