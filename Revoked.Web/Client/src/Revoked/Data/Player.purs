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

-- | Represents the state of the player
type PlayerState = { 
    pos :: Position, 
    appear :: PlayerAppear,
    sprite :: Sprite,
    velocity :: Velocity,
    onFloor :: Boolean,
    gun :: Gun,
    health :: Int
}

-- | Represents the player
data Player = Player PlayerState

-- | The direction the player is facing
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

-- | Updates the specified player using a collision check based on the user input
updatePlayer :: Input -> Player -> X -> (Player -> Boolean) -> { player :: Player, bullets :: Array Bullet }
updatePlayer i (Player p) distance collisionCheck = { player: newPlayer, bullets: bullets }
    where
        -- Update the gun and get the bullets fired from it
        { gun: updatedGun, bullets: bullets } = updateGunWithInput i p.gun

        -- update the player position and velocity
        newVelocityBasedOnGravity = updateVelocity i p.velocity p.onFloor
        newPositionBasedOnVelocity = updatePosition p.pos newVelocityBasedOnGravity
        newAppear = updateAppear i p.appear
        playerBasedOnVelocity = p { 
            pos = newPositionBasedOnVelocity, 
            appear = newAppear,
            velocity = newVelocityBasedOnGravity,
            gun = updatedGun
        }

        -- Adjust the player based on collision
        playerBasedOnMapCollision = collide p.pos playerBasedOnVelocity distance (collisionCheck <<< Player)
        playerBasedOnMonitorCollision = beInMonitor p.pos playerBasedOnMapCollision
        playerBasedOnAdjustedVelocity = adjustVelocity p.pos playerBasedOnMonitorCollision
        playerWithAdjustedGun = adjustGunPosition playerBasedOnAdjustedVelocity

        -- Update sprite based on new player position
        newPlayer = Player $ updateSprite p playerWithAdjustedGun

-- | Updates the direction the player is facing based on user input.
updateAppear :: Input -> PlayerAppear -> PlayerAppear
updateAppear i currentAppear = case i.active.isA, i.active.isD of
    true, false -> PlayerBackward 
    false, true -> PlayerForward
    _, _ -> currentAppear

-- | Updates the player's velocity based on the user input, whether the player is on the floor and 
-- | the player's current velocity.
updateVelocity :: Input -> Velocity -> Boolean -> Velocity
updateVelocity i currentVelocity onFloor = { xSpeed: xSpeed, ySpeed: ySpeed }
    where
        xSpeed = updateVelocityX i currentVelocity.xSpeed
        ySpeed = updateVelocityY i currentVelocity.ySpeed onFloor

-- | Updates the player's velocity based on the user input, whether the player is on the floor and 
-- | the player's current vertical velocity.
updateVelocityY :: Input -> Number -> Boolean -> Number 
updateVelocityY i ySpeed onFloor = case i.active.isSpace, onFloor of
    true, true -> maxPlayerSpeedY
    _, _ -> case ySpeed + gravity >= -maxPlayerSpeedY of
        true -> ySpeed + gravity
        false -> -maxPlayerSpeedY

-- | Updates the player's velocity based on the user input and the player's current horizontal 
-- | velocity.
updateVelocityX :: Input -> Number -> Number
updateVelocityX i xSpeed = case i.active.isA, i.active.isD of
    true, false -> -maxPlayerSpeedX
    false, true -> maxPlayerSpeedX
    _, _ -> if (abs xSpeed) >= 1.0 then xSpeed * frictionFactor else 0.0 

-- | Updates the new player `Sprite` based on the previous state of the player.
updateSprite :: PlayerState -> PlayerState -> PlayerState
updateSprite oldPlayer newPlayer = newPlayer { sprite = newSprite }
    where 
        newXSpeed = newPlayer.velocity.xSpeed
        appearChanged = newPlayer.appear /= oldPlayer.appear
        onFloorChanged = newPlayer.onFloor /= oldPlayer.onFloor
        speedChanged = newXSpeed /= oldPlayer.velocity.xSpeed

        newSprite = if appearChanged || onFloorChanged || speedChanged
            then newPlayerSprite newPlayer.appear newXSpeed newPlayer.onFloor
            else incrementFrame newPlayer.sprite

-- | Determines the new player sprite based on the player's horizontal speed, whether or not they are 
-- | on the floor and which direction they are facing.
newPlayerSprite :: PlayerAppear -> Number -> Boolean -> Sprite
newPlayerSprite appear newXSpeed onFloor = sprite
    where
        isStill = newXSpeed == 0.0
        sprite = case appear, onFloor, isStill of
            PlayerBackward, true, false -> S.playerLeft
            PlayerForward, true, false -> S.playerRight
            PlayerBackward, _, _ -> S.playerStandingLeft
            PlayerForward, _, _ -> S.playerStandingRight   

-- | Fires and updates the gun based on the user input. If the user has not pressed the fire button 
-- | then the Gun is just updated.
updateGunWithInput :: Input -> Gun -> { gun :: Gun, bullets :: Array Bullet }
updateGunWithInput i g = if i.active.isEnter
    then fireAndUpdateGun g
    else { gun: updateGun g, bullets: [] }

-- | Adjusts the player's gun to be in the right position with the correct rotation.
adjustGunPosition :: PlayerState -> PlayerState
adjustGunPosition p = playerWithAdjustedGun
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

-- | Updates the specified `Player` with the specified `Gun`. If no `Gun` is specicied then 
-- | the current `Gun` will remain. If the player runs out of ammo in their current `Gun` then 
-- | the `Gun` will be reset to the default. 
updatePlayerGun :: (Maybe Gun) -> Player -> Player
updatePlayerGun collidedGun (Player p) = Player newPlayer
    where 
        newPlayer = case (shotCount p.gun) > 0, collidedGun of
            true, Nothing -> p
            false, Nothing -> adjustGunPosition $ p { gun = defaultPistolGun p.pos 0 }
            _, Just gun -> adjustGunPosition $ p { gun = gun }

-- | The initial player state with given `Position`.
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

-- | Adjusts the player's velocity based on their change in position. If the position hasnt 
-- | changed in a given direction set the velocity in that direction to zero.
adjustVelocity :: Position -> PlayerState -> PlayerState
adjustVelocity oldPos newPlayer = newPlayer { velocity = velocity } 
    where
        currentVelocity = newPlayer.velocity
        newPos = newPlayer.pos
        xSpeed = if oldPos.x == newPos.x
            then 0.0
            else currentVelocity.xSpeed
        ySpeed = if oldPos.y == newPos.y
            then 0.0
            else currentVelocity.ySpeed
        velocity = {
            xSpeed: xSpeed,
            ySpeed: ySpeed
        }  

-- | Performs collision detection with the given collision function on the specified player and 
-- | adjust's its position such that it is in contact with the blocks it has collided with if that
-- | is neccessary.
collide :: Position -> PlayerState -> X -> (PlayerState -> Boolean) -> PlayerState
collide oldPos newPlayer distance collisionCheck = newPlayer { pos = newPosition, onFloor = newOnFloor }
    where
        newPos = newPlayer.pos
        size = newPlayer.sprite.size

        -- Build players that have only moved in x or y
        xChangePlayer = newPlayer { 
            pos = { 
                x: newPos.x, 
                y: oldPos.y 
            }
        }
        yChangePlayer = newPlayer { 
            pos = { 
                x: oldPos.x, 
                y: newPos.y 
            }
        }

        -- Check if the player has collided in x, y or both
        xCollide = collisionCheck xChangePlayer
        yCollide = collisionCheck yChangePlayer
        bothCollide = collisionCheck newPlayer

        -- Determine adjusted X and Y
        adjustedX = adjustX oldPos.x newPos.x distance size.width
        adjustedY = adjustY oldPos.y newPos.y size.height 

        -- Determine new position and on floor status
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

-- | Adjusts the specified player such that it is within the boundries of the monitor. 
beInMonitor :: Position -> PlayerState -> PlayerState
beInMonitor oldPos p = p { pos = { x: x, y: y } }
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

-- | Retrieves the number of shots the player has in their current `Gun`.
playerShotCount :: Player -> Int
playerShotCount (Player p) = shotCount p.gun

-- | Retreives whether the player's current `Gun` is inifite ammo.
playerGunIsInfinite :: Player -> Boolean
playerGunIsInfinite (Player p) = isInfinite p.gun