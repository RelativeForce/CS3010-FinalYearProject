module Emo8.Utils where

import Prelude

import Data.Traversable (traverse)
import Effect (Effect)
import Emo8.Excepiton (orErrMsg)
import Emo8.Parse (RawMap, parseTileMap)
import Data.Int (toNumber, floor)
import Assets.AssetMapper (emojiToImage)
import Emo8.Types (Asset, MonitorSize, Size, X, Y, Position, Velocity, IdX, IdY, MapId, ScaledImage, AssetId, Deg, Vector)
import Data.Array (reverse, (!!))
import Data.Foldable (elem, foldr)
import Data.Maybe (Maybe(..))
import Math (sqrt, atan, pi, abs, cos, sin)

-- | Collision detection if an object protrudes out of monitor
isMonitorCollide :: MonitorSize -> Size -> X -> Y -> Boolean
isMonitorCollide ms objectSize x y
    = x < 0
    || x + objectSize.width - 1 > ms.width
    || y < 0
    || y + objectSize.height - 1 > ms.height

xor :: Boolean -> Boolean -> Boolean
xor a b = (not a && b) || (not b && a)

-- | Collision detection if an object completely protrudes out of monitor
isOutOfMonitor :: MonitorSize -> Size -> X -> Y -> Boolean
isOutOfMonitor ms objectSize x y
    = x + objectSize.width - 1 < 0
    || x > ms.width
    || y + objectSize.height - 1 < 0
    || y > ms.height

distanceFromOrigin :: Position -> Number
distanceFromOrigin p = sqrt $ toNumber $ (p.x * p.x) + (p.y * p.y)

magnitude :: Velocity -> Number
magnitude v = sqrt $ (v.xSpeed * v.xSpeed) + (v.ySpeed * v.ySpeed)

vectorTo :: Position -> Position -> Vector
vectorTo positionA positionB = { x: positionB.x - positionA.x, y: positionB.y - positionA.y }

toPosition :: Velocity -> Position
toPosition v = { x: floor v.xSpeed, y: floor v.ySpeed }

toVelocity :: Position -> Velocity
toVelocity p = { xSpeed: (toNumber p.x), ySpeed: (toNumber p.y)  } 

normalise :: Velocity -> Velocity
normalise v = { xSpeed: v.xSpeed / s, ySpeed: v.ySpeed / s } 
    where
        s = (abs v.xSpeed) + (abs v.ySpeed)

distanceBetween :: Position -> Position -> Number
distanceBetween a b = distanceFromOrigin $ vectorTo a b

sum :: Vector -> Vector -> Vector
sum a b = { x: a.x + b.x, y: a.y + b.y }

xComponent :: Deg -> Number -> Number
xComponent a length = length * (cos $ degToRadians a)

yComponent :: Deg -> Number -> Number
yComponent a length = length * (sin $ degToRadians a)

degToRadians :: Deg -> Number
degToRadians d = (pi * toNumber d) / 180.0

radiansToDeg :: Number -> Deg
radiansToDeg r = floor $ (180.0 * r) / pi

inLeftDirection :: Deg -> Boolean
inLeftDirection d = d > 90 && d < 270

-- | Collision detection between two objects
isCollide :: Size -> X -> Y -> Size -> X -> Y -> Boolean
isCollide objectSizeA xA yA objectSizeB xB yB
    = pAlx <= pBrx
    && pBlx <= pArx
    && pAby <= pBty
    && pBby <= pAty
    where
        pAlx = xA
        pArx = xA + objectSizeA.width - 1
        pAby = yA
        pAty = yA + objectSizeA.height - 1 
        pBlx = xB
        pBrx = xB + objectSizeB.width - 1
        pBby = yB
        pBty = yB + objectSizeB.height - 1 

isMapCollide :: Asset -> MapId -> Size -> Array AssetId -> Size -> X -> Y -> Boolean
isMapCollide asset mId mSize collidableObjectIds size x y = foldr f false [lbE, rbE, ltE, rtE]
    where
        lx = x
        rx = x + size.width - 1
        by = y
        ty = y + size.height - 1
        f :: Maybe ScaledImage -> Boolean -> Boolean
        f maybeImage b = case maybeImage of
            Just img | elem img.id collidableObjectIds -> true
            _ -> b
        lbE = getMapTile asset mId (lx / mSize.width) (by / mSize.height)
        rbE = getMapTile asset mId (rx / mSize.width) (by / mSize.height)
        ltE = getMapTile asset mId (lx / mSize.width) (ty / mSize.height)
        rtE = getMapTile asset mId (rx / mSize.width) (ty / mSize.height)

getMapTile :: Asset -> MapId -> IdX -> IdY -> Maybe ScaledImage
getMapTile ass mId xId yId = maybeTile
    where 
        map = case ass.mapData !! mId of
            Nothing -> []
            Just m -> m
        maybeAtIndex = reverse map !! yId >>= flip (!!) xId
        maybeTile = case maybeAtIndex of
            Nothing -> Nothing
            Just e -> e

-- | Make asset data from raw maps.
-- | If there are unparsable strings, exception raised when executing javascript.
mkAsset :: Array RawMap -> Effect Asset
mkAsset rms = do
    ms <- orErrMsg $ traverse (\m -> parseTileMap m emojiToImage) rms 
    pure { mapData: ms}

-- | Rotation is anti-clockwise from the positive x axis
angle :: Vector -> Deg
angle v = mod angleBasedOnDirection 360
    where
        angleFromHorizontalAxis = radiansToDeg $ atan $ (toNumber v.y) / (toNumber v.x)
        isRight = v.x > 0
        isUp = v.y > 0
        isDown = v.y < 0
        isLeft = v.x < 0
        angleBasedOnDirection = case isRight, isDown, isLeft, isUp of
            false, true, true, false -> 180 + angleFromHorizontalAxis
            false, false, true, true -> 180 + angleFromHorizontalAxis
            false, true, false, false -> 270
            false, false, false, true -> 90
            false, false, true, false -> 180
            true, false, false, false -> 0
            false, false, false, false -> 0
            _, _, _, _ -> angleFromHorizontalAxis

updatePosition :: Position -> Velocity -> Position
updatePosition p v = { x: x, y: y }
    where
        x = floor $ (toNumber p.x) + v.xSpeed
        y = floor $ (toNumber p.y) + v.ySpeed
