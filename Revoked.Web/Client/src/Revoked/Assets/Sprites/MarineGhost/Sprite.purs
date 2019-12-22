module Assets.Sprites.MarineGhost.Sprite where

import Emo8.Types (Sprite)
import Assets.Sprites.MarineGhost.Frame0 (frame0Data)
import Assets.Sprites.MarineGhost.Frame1 (frame1Data)
import Assets.Sprites.MarineGhost.Frame2 (frame2Data)
import Assets.Sprites.MarineGhost.Frame3 (frame3Data)
import Assets.Sprites.MarineGhost.Frame4 (frame4Data)
import Assets.Sprites.MarineGhost.Frame5 (frame5Data)
import Assets.Sprites.MarineGhost.Frame6 (frame6Data)
import Assets.Sprites.MarineGhost.Frame7 (frame7Data)
import Assets.Sprites.MarineGhost.Frame8 (frame8Data)
import Assets.Sprites.MarineGhost.Frame9 (frame9Data)
import Assets.AssetIds as Id

marineGhost:: Sprite
marineGhost = {
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
        frame8Data,
        frame7Data,
        frame6Data,
        frame5Data,
        frame4Data,
        frame3Data,
        frame2Data,
        frame1Data 
    ],
    frameIndex: 0,
    framesPerSecond: 2,
    frameCount: 18,
    size: {
        width: 21,
        height: 31
    },
    id: Id.marineGhostId
}