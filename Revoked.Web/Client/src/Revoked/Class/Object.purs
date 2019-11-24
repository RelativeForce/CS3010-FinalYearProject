module Class.Object where
  
import Prelude
import Emo8.Action.Draw (Draw)
import Emo8.Types (Size, Position)
  
class Object s where
    size :: s -> Size
    position :: s -> Position
    scroll :: Int -> s -> s

class Object s <= ObjectDraw s where
    draw :: s -> Draw Unit

vectorTo :: forall a b. Object a => Object b => a -> b -> Position
vectorTo a b = { x: positionA.x - positionB.x, y: positionA.y - positionB.y }
    where 
        positionA = position a
        positionB = position b