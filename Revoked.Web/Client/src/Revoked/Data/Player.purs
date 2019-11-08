module Data.Player where

import Prelude

import Class.Object (class Object, class ObjectDraw, position)
import Constants (maxPlayerSpeedX, maxPlayerSpeedY, gravity, frictionFactor, mapTileSize)
import Collision (isCollWorld)
import Data.Bullet (Bullet, BulletAppear(..), newBullet)
import Data.Sprites as S
import Data.Int (toNumber, floor)
import Math (abs)
import Emo8.Action.Draw (drawRotatedSprite)
import Emo8.Data.Sprite (incrementFrame)
import Emo8.Input (Input)
import Emo8.Types (Sprite, Velocity, X, Position)
import Emo8.Utils (defaultMonitorSize)
import Emo8.Action.Update (Update)

data Player = Player { 
    pos :: Position, 
    energy :: Int, 
    appear :: Appear,
    sprite :: Sprite,
    velocity :: Velocity,
    onFloor :: Boolean
}

data Appear = Stable | Forword | Backword

instance objectPlayer :: Object Player where
    size (Player p) = p.sprite.size
    position (Player p) = p.pos

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

updatePosition :: Position -> Velocity -> Position
updatePosition p v = { x: x, y: y }
    where
        x = floor $ (toNumber p.x) + v.xSpeed
        y = floor $ (toNumber p.y) + v.ySpeed

addBullet :: Input -> Player -> Array Bullet
addBullet i (Player p) =
    case (i.isEnter && (canFire p.energy)), p.appear of
        true, Backword -> [ newBullet (Backward) p.pos ]
        true, _ -> [ newBullet (Forward) p.pos ]
        false, _ -> []

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
canFire energy = energy >= 10

adjustVelocity :: Position -> Player -> Player
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

collide :: Position -> Player -> X -> (Player -> Update Boolean) -> Update Player
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
            false, false, false -> newPos
            _, _, _ -> { 
                x: adjustX oldPos.x newPos.x distance, 
                y: adjustY oldPos.y newPos.y 
            }
        newOnFloor = yCollide
    pure $ Player $ newPlayer { 
        pos = newPosition, 
        onFloor = newOnFloor
    }

adjustY :: Int -> Int -> Int
adjustY oldY newY = 
    if (newY > oldY) -- If moving up
        then newY - (mod newY mapTileSize.height)
        else newY - (mod newY mapTileSize.height) + mapTileSize.height
        
adjustX :: Int -> Int -> Int -> Int
adjustX oldX newX distance = 
    if (newX > oldX) -- If moving Right
        then newX - (mod (distance + newX) mapTileSize.width)
        else newX - (mod (distance + newX) mapTileSize.width) + mapTileSize.width

beInMonitor :: Position -> Player -> Player
beInMonitor pos (Player np) = Player $ np { pos = { x: npx, y: npy } }
    where
        size = np.sprite.size
        width = size.width
        height = size.height
        npos = np.pos
        isCollX = isCollWorld size { x: npos.x, y: pos.y }
        isCollY = isCollWorld size { x: pos.x, y: npos.y }
        npx = case isCollX, (npos.x < pos.x) of
            true, true -> 0
            true, false -> defaultMonitorSize.width - width
            _, _ -> npos.x
        npy = case isCollY, (npos.y < pos.y) of
            true, true -> 0
            true, false -> defaultMonitorSize.height - height
            _, _ -> npos.y