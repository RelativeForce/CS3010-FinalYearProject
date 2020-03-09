module Revoked.Class.MortalEntity where
  
import Emo8.Class.Object (class Object)

-- | The class definition for any `Object` that has health. These `Object`s can 
-- | be damaged and health.
class Object s <= MortalEntity s where

    -- | Retrieve the health value of the specified `MortalEntity`.
    health :: s -> Int

    -- | Inflict the specified amount of damage on the specified `MortalEntity`.
    damage :: s -> Int -> s

    -- | Add the specified amount of health to the specified `MortalEntity`.
    heal :: s -> Int -> s