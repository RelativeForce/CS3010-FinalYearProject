module Data.Player where

import Prelude

import Assets.Sprites as S
import Class.Object (class Object, class ObjectDraw, position)
import Collision (isCollWorld, adjustY, adjustX)
import Constants (maxPlayerSpeedX, maxPlayerSpeedY, gravity, frictionFactor)
import Data.Bullet (Bullet, BulletAppear(..), newBullet)
import Emo8.Action.Draw (drawSprite)
import Emo8.Data.Sprite (incrementFrame)
import Emo8.Input (Input)
import Emo8.Types (Sprite, Velocity, X, Position, Size)
import Emo8.Utils (defaultMonitorSize, updatePosition)
import Math (abs)

data Player = Player { 
    pos :: Position, 
    energy :: Int, 
    appear :: PlayerAppear,
    sprite :: Sprite,
    velocity :: Velocity,
    onFloor :: Boolean
}

data PlayerAppear = PlayerForward | PlayerBackward

instance playerAppearEqual :: Eq PlayerAppear where
    eq (PlayerForward) (PlayerForward) = true
    eq (PlayerBackward) (PlayerBackward) = true
    eq _ _ = false

instance objectPlayer :: Object Player where
    size (Player p) = p.sprite.size
    position (Player p) = p.pos
    scroll offset (Player p) = Player $ p { pos = { x: p.pos.x + offset, y: p.pos.y }}

instance objectDrawPlayer :: ObjectDraw Player where
    draw o@(Player p) = drawSprite p.sprite (position o).x (position o).y

updatePlayer :: Input -> Player -> X -> (Player -> Boolean) -> Player
updatePlayer i (Player p) distance collisionCheck = newPlayer
    where
        newVelocityBasedOnGravity = updateVelocity i p.velocity p.onFloor
        newPositionBasedOnVelocity = updatePosition p.pos newVelocityBasedOnGravity
        newEnergy = updateEnergy p.energy i
        newAppear = updateAppear i p.appear
        playerBasedOnVelocity = Player $ p { 
            pos = newPositionBasedOnVelocity, 
            energy = newEnergy, 
            appear = newAppear,
            velocity = newVelocityBasedOnGravity
        }
        playerBasedOnMapCollision = collide p.pos playerBasedOnVelocity distance collisionCheck
        playerBasedOnMonitorCollision = beInMonitor p.pos playerBasedOnMapCollision
        playerBasedOnAdjustedVelocity = adjustVelocity p.pos playerBasedOnMonitorCollision
        newPlayer = updateSprite p.appear p.onFloor p.velocity.xSpeed playerBasedOnAdjustedVelocity
    
updateEnergy :: Int -> Input -> Int
updateEnergy energy i = case (canFire energy), i.active.isEnter of
            true, true -> 0
            true, false -> energy
            false, _ -> energy + 1

updateAppear :: Input -> PlayerAppear -> PlayerAppear
updateAppear i currentAppear = case i.active.isA, i.active.isD of
    true, false -> PlayerBackward 
    false, true -> PlayerForward
    _, _ -> currentAppear

updateVelocity :: Input -> Velocity -> Boolean -> Velocity
updateVelocity i currentVelocity onFloor = { xSpeed: xSpeed, ySpeed: ySpeed }
    where
        xSpeed = updateVelocityX i currentVelocity
        ySpeed = updateVelocityY i currentVelocity onFloor

updateVelocityY :: Input -> Velocity -> Boolean -> Number 
updateVelocityY i currentVelocity onFloor = case i.active.isSpace, onFloor of
    true, true -> maxPlayerSpeedY
    _, _ -> case currentVelocity.ySpeed + gravity >= -maxPlayerSpeedY of
        true -> currentVelocity.ySpeed + gravity
        false -> -maxPlayerSpeedY

updateVelocityX :: Input -> Velocity -> Number
updateVelocityX i currentVelocity = case i.active.isA, i.active.isD of
    true, false -> -maxPlayerSpeedX
    false, true -> maxPlayerSpeedX
    _, _ -> if (abs currentVelocity.xSpeed) >= 1.0 then currentVelocity.xSpeed * frictionFactor else 0.0 

updateSprite :: PlayerAppear -> Boolean -> Number -> Player -> Player
updateSprite oldAppear oldOnFloor oldXSpeed (Player newPlayer) = Player $ newPlayer {
    sprite = newSprite
}
    where 
        newXSpeed = newPlayer.velocity.xSpeed
        appearChanged = newPlayer.appear /= oldAppear
        onFloorChanged = newPlayer.onFloor /= oldOnFloor
        speedChanged = newXSpeed /= oldXSpeed
        newSprite = case appearChanged || onFloorChanged || speedChanged of
            true -> newPlayerSprite newPlayer.appear newXSpeed newPlayer.onFloor
            false -> incrementFrame newPlayer.sprite

newPlayerSprite :: PlayerAppear -> Number -> Boolean -> Sprite
newPlayerSprite appear newXSpeed onFloor = sprite
    where
        still = newXSpeed == 0.0
        sprite = case appear, onFloor, still of
            PlayerBackward, true, false -> S.playerLeft
            PlayerForward, true, false -> S.playerRight
            PlayerBackward, _, _ -> S.playerStandingLeft
            PlayerForward, _, _ -> S.playerStandingRight   

addBullet :: Input -> Player -> Array Bullet
addBullet i (Player p) = bulletArray
    where
        bulletPosition = initialBulletPosition p.pos p.sprite.size p.appear
        bulletArray = case (i.active.isEnter && (canFire p.energy)), p.appear of
            true, PlayerBackward -> [ newBullet (BulletBackward) bulletPosition ]
            true, PlayerForward -> [ newBullet (BulletForward) bulletPosition ]
            false, _ -> []

initialBulletPosition :: Position -> Size -> PlayerAppear -> Position
initialBulletPosition pos size (PlayerBackward) = {
            x: pos.x - size.width,
            y: pos.y + (size.height / 2)
        }
initialBulletPosition pos size (PlayerForward) = {
            x: pos.x + size.width,
            y: pos.y + (size.height / 2)
        }

initialPlayer :: Player
initialPlayer = Player { 
    pos: { 
        x: 0, 
        y: 40
    }, 
    energy: 30, 
    appear: PlayerForward,
    sprite: S.playerStandingRight,
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

collide :: Position -> Player -> X -> (Player -> Boolean) -> Player
collide oldPos (Player newPlayer) distance collisionCheck = Player $ newPlayer { 
    pos = newPosition, 
    onFloor = newOnFloor
}
    where
        newPos = newPlayer.pos
        size = newPlayer.sprite.size
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
        xCollide = collisionCheck xChangePlayer
        yCollide = collisionCheck yChangePlayer
        bothCollide = collisionCheck (Player newPlayer)
        newPosition = case xCollide, yCollide, bothCollide of
            true, false, _ -> { 
                x: adjustX oldPos.x newPos.x distance size.width, 
                y: newPos.y 
            }
            false, true, _ -> { 
                x: newPos.x, 
                y: adjustY oldPos.y newPos.y size.height 
            }
            false, false, false -> newPos
            _, _, _ -> { 
                x: adjustX oldPos.x newPos.x distance size.width, 
                y: adjustY oldPos.y newPos.y size.height 
            }
        newOnFloor = yCollide
    

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