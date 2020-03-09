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