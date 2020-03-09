module Revoked.Assets.Sprites.DroneExplosion.Sprite where

import Emo8.Types (Sprite)
import Revoked.Assets.Sprites.DroneExplosion.Frame0 (frame0Data)
import Revoked.Assets.Sprites.DroneExplosion.Frame1 (frame1Data)
import Revoked.Assets.Sprites.DroneExplosion.Frame2 (frame2Data)
import Revoked.Assets.Sprites.DroneExplosion.Frame3 (frame3Data)
import Revoked.Assets.Sprites.DroneExplosion.Frame4 (frame4Data)
import Revoked.Assets.Sprites.DroneExplosion.Frame5 (frame5Data)
import Revoked.Assets.Sprites.DroneExplosion.Frame6 (frame6Data)
import Revoked.Assets.Sprites.DroneExplosion.Frame7 (frame7Data)
import Revoked.Assets.Sprites.DroneExplosion.Frame8 (frame8Data)
import Revoked.Assets.Sprites.DroneExplosion.Frame9 (frame9Data)
import Revoked.Assets.Sprites.DroneExplosion.Frame10 (frame10Data)
import Revoked.Assets.Sprites.DroneExplosion.Frame11 (frame11Data)
import Revoked.Assets.Sprites.DroneExplosion.Frame12 (frame12Data)
import Revoked.Assets.Sprites.DroneExplosion.Frame13 (frame13Data)
import Revoked.Assets.AssetIds as Id

droneExplosion :: Sprite
droneExplosion = {
    frames: [ 
        frame0Data, 
        frame1Data, 
        frame2Data,
        frame3Data,
        frame4Data,
        frame5Data,
        frame6Data,
        frame7Data,
        frame8Data,
        frame9Data,
        frame10Data,
        frame11Data,
        frame12Data,
        frame13Data
    ],
    frameIndex: 0,
    framesPerSecond: 2,
    frameCount: 14,
    size: {
        width: 64,
        height: 64
    },
    id: Id.droneExplosionId
}