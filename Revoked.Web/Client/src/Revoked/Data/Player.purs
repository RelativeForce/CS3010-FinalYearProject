module Data.Player where

import Prelude

import Class.Object (class Object, class ObjectDraw, position)
import Constants (emoSize, maxPlayerSpeedX, maxPlayerSpeedY, gravity, frictionFactor)
import Data.Bullet (Bullet(..))
import Data.Sprites as S
import Data.Int (toNumber, floor)
import Emo8.Action.Draw (drawRotatedSprite)
import Emo8.Data.Sprite (incrementFrame)
import Emo8.Input (Input)
import Emo8.Types (Sprite, Velocity)
import Emo8.Utils (defaultMonitorSize)
import Types (Pos)

data Player = Player { 
    pos :: Pos, 
    energy :: Int, 
    appear :: Appear,
    sprite :: Sprite,
    velocity :: Velocity,
    onFloor :: Boolean
}

data Appear = Stable | Forword | Backword

instance objectPlayer :: Object Player where
    size _ = emoSize
    position (Player s) = s.pos

instance objectDrawPlayer :: ObjectDraw Player where
    draw o@(Player p) = case p.appear of
            Stable -> drawRotatedSprite p.sprite (position o).x (position o).y 0
            Forword -> drawRotatedSprite p.sprite (position o).x (position o).y (- 30)
            Backword -> drawRotatedSprite p.sprite (position o).x (position o).y 30

updatePlayer :: Input -> Player -> Player
updatePlayer i (Player p) =
    Player $ p { 
        pos = newPosition, 
        energy = newEnergy, 
        appear = newAppear,
        sprite = incrementFrame p.sprite,
        velocity = newVelocity,
        onFloor = p.onFloor
    }
    where
        newVelocity = updateVelocity i p.velocity p.onFloor
        newPosition = updatePosition p.pos newVelocity
        newEnergy = case (canEmit p.energy), i.isEnter of
            true, true -> 0
            true, false -> p.energy
            false, _ -> p.energy + 1
        newAppear =
            case i.isA, i.isD of
                true, false -> Backword 
                false, true -> Forword
                _, _ -> Stable 

updateVelocity :: Input -> Velocity -> Boolean -> Velocity
updateVelocity i currentVelocity onFloor = { xSpeed: xSpeed, ySpeed: ySpeed }
    where
        xSpeed = case i.isA, i.isD of
            true, false -> -maxPlayerSpeedX
            false, true -> maxPlayerSpeedX
            _, _ -> currentVelocity.xSpeed * frictionFactor
        ySpeed = case i.isSpace, onFloor of
            true, true -> maxPlayerSpeedY
            false, true -> 0.0
            _, false -> case currentVelocity.ySpeed + gravity >= -maxPlayerSpeedY of
                true -> currentVelocity.ySpeed + gravity
                false -> -maxPlayerSpeedY

updatePosition :: Pos -> Velocity -> Pos
updatePosition p v = { x: nx, y: ny }
    where
        nx = floor $ (toNumber p.x) + v.xSpeed
        ny = floor $ (toNumber p.y) + v.ySpeed

addBullet :: Input -> Player -> Array Bullet
addBullet i (Player p) =
    case i.isEnter && (canEmit p.energy) of
        true -> [ Normal { pos: p.pos } ]
        false -> []

initialPlayer :: Player
initialPlayer = Player { 
    pos: { 
        x: 0, 
        y: defaultMonitorSize.height / 2
    }, 
    energy: 30, 
    appear: Stable,
    sprite: S.player,
    velocity: {
        xSpeed: 0.0,
        ySpeed: 0.0
    },
    onFloor: true
}

canEmit :: Int -> Boolean
canEmit energy = energy > 29