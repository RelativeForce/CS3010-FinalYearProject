module Revoked.Data.Player where

import Prelude

import Data.Maybe (Maybe(..))
import Math (abs)

import Emo8.Action.Draw (drawSprite)
import Emo8.Data.Sprite (incrementFrame)
import Emo8.Input (Input)
import Emo8.Types (Sprite, Velocity, X, Position)
import Emo8.Utils (updatePosition)
import Emo8.Collision (isCollideWorld)
import Emo8.Constants (defaultMonitorSize)
import Emo8.Class.Object (class Object, class ObjectDraw, position, scroll, draw, size)

import Revoked.Assets.Sprites as S
import Revoked.Class.MortalEntity (class MortalEntity)
import Revoked.Collision (adjustY, adjustX)
import Revoked.Constants (maxPlayerSpeedX, maxPlayerSpeedY, gravity, frictionFactor, defaultPlayerHealth)
import Revoked.Data.Bullet (Bullet)
import Revoked.Data.Gun (Gun, defaultPistolGun, fireAndUpdateGun, setPositionAndRotation, shotCount, updateGun, isInfinite)

data Player = Player { 
    pos :: Position, 
    appear :: PlayerAppear,
    sprite :: Sprite,
    velocity :: Velocity,
    onFloor :: Boolean,
    gun :: Gun,
    health :: Int
}

data PlayerAppear = PlayerForward | PlayerBackward

instance playerAppearEqual :: Eq PlayerAppear where
    eq (PlayerForward) (PlayerForward) = true
    eq (PlayerBackward) (PlayerBackward) = true
    eq _ _ = false

instance objectPlayer :: Object Player where
    size (Player p) = p.sprite.size
    position (Player p) = p.pos
    scroll offset (Player p) = Player $ p { 
        pos = { x: p.pos.x + offset, y: p.pos.y },
        gun = scroll offset p.gun
    }

instance objectDrawPlayer :: ObjectDraw Player where
    draw o@(Player p) = do
        drawSprite p.sprite (position o).x (position o).y
        draw p.gun

instance mortalEntityPlayer :: MortalEntity Player where
    health (Player p) = p.health
    damage (Player p) healthLoss = Player $ p { health = p.health - healthLoss }
    heal (Player p) healthBonus = Player $ p { health = p.health + healthBonus }

updatePlayer :: Input -> Player -> X -> (Player -> Boolean) -> { player :: Player, bullets :: Array Bullet }
updatePlayer i (Player p) distance collisionCheck = { player: newPlayer, bullets: bullets }
    where
        { gun: updatedGun, bullets: bullets } = updateGunWithInput i p.gun
        newVelocityBasedOnGravity = updateVelocity i p.velocity p.onFloor
        newPositionBasedOnVelocity = updatePosition p.pos newVelocityBasedOnGravity
        newAppear = updateAppear i p.appear
        playerBasedOnVelocity = Player $ p { 
            pos = newPositionBasedOnVelocity, 
            appear = newAppear,
            velocity = newVelocityBasedOnGravity,
            gun = updatedGun
        }
        playerBasedOnMapCollision = collide p.pos playerBasedOnVelocity distance collisionCheck
        playerBasedOnMonitorCollision = beInMonitor p.pos playerBasedOnMapCollision
        playerBasedOnAdjustedVelocity = adjustVelocity p.pos playerBasedOnMonitorCollision
        playerWithAdjustedGun = adjustGunPosition playerBasedOnAdjustedVelocity
        newPlayer = updateSprite p.appear p.onFloor p.velocity.xSpeed playerWithAdjustedGun

updateAppear :: Input -> PlayerAppear -> PlayerAppear
updateAppear i currentAppear = case i.active.isA, i.active.isD of
    true, false -> PlayerBackward 
    false, true -> PlayerForward
    _, _ -> currentAppear

setGun :: Player -> Gun -> Player
setGun (Player p) newGun = Player $ p { gun = newGun }

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
updateSprite oldAppear oldOnFloor oldXSpeed (Player newPlayer) = Player $ newPlayer { sprite = newSprite }
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

updateGunWithInput :: Input -> Gun -> { gun :: Gun, bullets :: Array Bullet }
updateGunWithInput i g = if i.active.isEnter
    then fireAndUpdateGun g
    else { gun: updateGun g, bullets: [] }

adjustGunPosition :: Player -> Player
adjustGunPosition (Player p) = Player playerWithAdjustedGun
    where 
        gunSize = size p.gun
        gunPosX = case p.appear of
            PlayerBackward -> p.pos.x + gunSize.width - 12
            PlayerForward -> p.pos.x + p.sprite.size.width - gunSize.width + 12
        gunPosY = case p.appear of
            PlayerBackward -> p.pos.y + (p.sprite.size.height / 2) - (gunSize.height) - 3
            PlayerForward -> p.pos.y + (p.sprite.size.height / 2) - 3 
        gunPos = { x: gunPosX, y: gunPosY }
        angle = case p.appear of
            PlayerBackward -> 180
            PlayerForward -> 0

        playerWithAdjustedGun = p {
            gun = setPositionAndRotation p.gun gunPos angle
        }

updatePlayerGun :: (Maybe Gun) -> Player -> Player
updatePlayerGun collidedGun (Player p) = newPlayer
    where 
        newPlayer = case (shotCount p.gun) > 0, collidedGun of
            true, Nothing -> Player p
            false, Nothing -> setGun (Player p) (defaultPistolGun p.pos 0)
            _, Just gun -> adjustGunPosition $ setGun (Player p) gun

initialPlayer :: Position -> Player
initialPlayer pos = Player { 
    pos: pos, 
    appear: PlayerForward,
    sprite: S.playerStandingRight,
    velocity: {
        xSpeed: 0.0,
        ySpeed: 0.0
    },
    onFloor: true,
    gun: defaultPistolGun (pos { x = pos.x + 10 }) 0,
    health: defaultPlayerHealth
}

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
        adjustedX = adjustX oldPos.x newPos.x distance size.width
        adjustedY = adjustY oldPos.y newPos.y size.height 
        newOnFloor = yCollide && oldPos.y > newPos.y
        newPosition = case xCollide, yCollide, bothCollide of
            true, false, _ -> { 
                x: adjustedX, 
                y: newPos.y 
            }
            false, true, _ -> { 
                x: newPos.x, 
                y: adjustedY
            }
            false, false, true -> { 
                x: adjustedX, 
                y: newPos.y 
            }
            false, false, false -> newPos
            _, _, _ -> { 
                x: adjustedX, 
                y: adjustedY
            }
        
beInMonitor :: Position -> Player -> Player
beInMonitor oldPos (Player p) = Player $ p { pos = { x: x, y: y } }
    where
        size = p.sprite.size
        width = size.width
        height = size.height
        pos = p.pos
        isCollX = isCollideWorld $ Player $ p { pos = { x: pos.x, y: oldPos.y } }
        isCollY = isCollideWorld $ Player $ p { pos = { x: oldPos.x, y: pos.y } }
        x = case isCollX, (pos.x < oldPos.x) of
            true, true -> 0
            true, false -> defaultMonitorSize.width - width
            _, _ -> pos.x
        y = case isCollY, (pos.y < oldPos.y) of
            true, true -> 0
            true, false -> defaultMonitorSize.height - height
            _, _ -> pos.y

playerShotCount :: Player -> Int
playerShotCount (Player p) = shotCount p.gun

playerGunIsInfinite :: Player -> Boolean
playerGunIsInfinite (Player p) = isInfinite p.gun