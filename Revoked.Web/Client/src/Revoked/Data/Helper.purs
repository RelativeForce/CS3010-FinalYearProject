module Revoked.Data.Helper where

import Prelude

import Revoked.Class.MortalEntity (class MortalEntity, health)

isDead :: forall a. MortalEntity a => a -> Boolean
isDead entity = (health entity) <= 0