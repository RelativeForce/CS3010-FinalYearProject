module Class.MortalEntity where
  
import Class.Object (class Object)

class Object s <= MortalEntity s where
    health :: s -> Int
    damage :: s -> Int -> s
    heal :: s -> Int -> s