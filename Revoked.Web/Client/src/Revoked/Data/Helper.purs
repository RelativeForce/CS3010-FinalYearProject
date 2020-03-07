module Data.Helper where

import Prelude

import Class.Object (class MortalEntity, health)

isDead :: forall a. MortalEntity a => a -> Boolean
isDead entity = (health entity) <= 0