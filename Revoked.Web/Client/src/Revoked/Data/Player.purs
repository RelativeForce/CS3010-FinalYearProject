module Data.Player where

import Prelude

import Class.Object (class Object, class ObjectDraw, position)
import Constants (emoSize, maxPlayerSpeedX, maxPlayerSpeedY, gravity, frictionFactor, mapTileWidth)
import Collision (isCollWorld)
import Data.Bullet (Bullet(..))
import Data.Sprites as S
import Data.Int (toNumber, floor)
import Math (abs)
import Emo8.Action.Draw (drawRotatedSprite)
import Emo8.Data.Sprite (incrementFrame)
import Emo8.Input (Input)
import Emo8.Types (Sprite, Velocity, X)
import Emo8.Utils (defaultMonitorSize)
import Emo8.Action.Update (Update)
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

updatePlayer :: Input -> Player -> X -> (Player -> Update Boolean) -> Update Player
updatePlayer i (Player p) distance collisionCheck = do
    let 
        newVelocityBasedOnGravity = updateVelocity i p.velocity p.onFloor

        newPositionBasedOnVelocity = updatePosition p.pos newVelocityBasedOnGravity

        newEnergy = case (canFire p.energy), i.isEnter of
            true, true -> 0
            true, false -> p.energy
            false, _ -> p.energy + 1

        newAppear =
            case i.isA, i.isD of
                true, false -> Backword 
                false, true -> Forword
                _, _ -> Stable 

        playerBasedOnVelocity = Player $ p { 
            pos = newPositionBasedOnVelocity, 
            energy = newEnergy, 
            appear = newAppear,
            sprite = incrementFrame p.sprite,
            velocity = newVelocityBasedOnGravity,
            onFloor = p.onFloor
        }

    playerBasedOnMapCollision <- collide p.pos playerBasedOnVelocity distance collisionCheck

    let
        playerBasedOnMonitorCollision = beInMonitor p.pos playerBasedOnMapCollision
        newPlayer = adjustVelocity p.pos playerBasedOnMonitorCollision
    
    pure newPlayer

updateVelocity :: Input -> Velocity -> Boolean -> Velocity
updateVelocity i currentVelocity onFloor = { xSpeed: xSpeed, ySpeed: ySpeed }
    where
        xSpeed = case i.isA, i.isD of
            true, false -> -maxPlayerSpeedX
            false, true -> maxPlayerSpeedX
            _, _ -> if (abs currentVelocity.xSpeed) >= 1.0 then currentVelocity.xSpeed * frictionFactor else 0.0 
        ySpeed = case i.isSpace, onFloor of
            true, true -> maxPlayerSpeedY
            false, true -> 0.0
            _, false -> case currentVelocity.ySpeed + gravity >= -maxPlayerSpeedY of
                true -> currentVelocity.ySpeed + gravity
                false -> -maxPlayerSpeedY

updatePosition :: Pos -> Velocity -> Pos
updatePosition p v = { x: x, y: y }
    where
        x = floor $ (toNumber p.x) + v.xSpeed
        y = floor $ (toNumber p.y) + v.ySpeed

addBullet :: Input -> Player -> Array Bullet
addBullet i (Player p) =
    case i.isEnter && (canFire p.energy) of
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

canFire :: Int -> Boolean
canFire energy = energy > 29

adjustVelocity :: Pos -> Player -> Player
adjustVelocity oldPos (Player new) = Player $ new { 
    velocity = {
        xSpeed: xSpeed,
        ySpeed: ySpeed
    }   
} 
    where
        currentVelocity = new.velocity
        newPos = new.pos
        xSpeed = if oldPos.x == newPos.x
            then 0.0
            else currentVelocity.xSpeed
        ySpeed = if oldPos.y == newPos.y
            then 0.0
            else currentVelocity.ySpeed

collide :: Pos -> Player -> X -> (Player -> Update Boolean) -> Update Player
collide oldPos (Player newPlayer) distance collisionCheck = do
    let 
        newPos = newPlayer.pos
        xChangePlayer = Player $ newPlayer { 
            pos = { 
                x: newPos.x, 
                y: oldPos.y 
            }
        }
        yChangePlayer = Player $ newPlayer { 
            pos = { 
                x: oldPos.x, 
                y: newPos.y 
            }
        }
    xCollide <- collisionCheck xChangePlayer
    yCollide <- collisionCheck yChangePlayer
    bothCollide <- collisionCheck (Player newPlayer)
    let newPosition = case xCollide, yCollide, bothCollide of
            true, false, _ -> { 
                x: adjustX oldPos.x newPos.x distance, 
                y: newPos.y 
            }
            false, true, _ -> { 
                x: newPos.x, 
                y: adjustY oldPos.y newPos.y
            }
            false, false, true -> { 
                x: adjustX oldPos.x newPos.x distance, 
                y: adjustY oldPos.y newPos.y 
            }
            _, _, _ -> newPos
        newOnFloor = yCollide
    pure $ Player $ newPlayer { 
        pos = newPosition, 
        onFloor = newOnFloor
    }

adjustY :: Int -> Int -> Int
adjustY oldY newY = 
    if (newY > oldY) -- If moving up
        then newY - (mod newY mapTileWidth)
        else newY - (mod newY mapTileWidth) + mapTileWidth
        
adjustX :: Int -> Int -> Int -> Int
adjustX oldX newX distance = 
    if (newX > oldX) -- If moving Right
        then newX - (mod (distance + newX) mapTileWidth)
        else newX - (mod (distance + newX) mapTileWidth) + mapTileWidth

beInMonitor :: Pos -> Player -> Player
beInMonitor pos (Player np) = Player $ np { pos = { x: npx, y: npy } }
    where
        width = np.sprite.width
        height = np.sprite.height
        npos = np.pos
        isCollX = isCollWorld width { x: npos.x, y: pos.y }
        isCollY = isCollWorld height { x: pos.x, y: npos.y }
        npx = case isCollX, (npos.x < pos.x) of
            true, true -> 0
            true, false -> defaultMonitorSize.width - width
            _, _ -> npos.x
        npy = case isCollY, (npos.y < pos.y) of
            true, true -> 0
            true, false -> defaultMonitorSize.height - height
            _, _ -> npos.y