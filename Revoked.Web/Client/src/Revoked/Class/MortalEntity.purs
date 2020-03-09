module Revoked.Class.MortalEntity where
  
import Emo8.Class.Object (class Object)

class Object s <= MortalEntity s where
    health :: s -> Int
    damage :: s -> Int -> s
    heal :: s -> Int -> s