// Generated by purs version 0.12.5
"use strict";
var Constants = require("../Constants/index.js");
var Data_Bullet = require("../Data.Bullet/index.js");
var Left = (function () {
    function Left() {

    };
    Left.value = new Left();
    return Left;
})();
var Right = (function () {
    function Right() {

    };
    Right.value = new Right();
    return Right;
})();
var reloadPistol = function (p) {
    return {
        pos: p.pos,
        angle: p.angle,
        shotCoolDown: 0,
        shotCount: Constants.pistolMagazineSize,
        appear: p.appear,
        sprite: p.sprite
    };
};
var canFire = function (p) {
    return p.shotCoolDown === 0 && p.shotCount > 0;
};
var firePistol = function (p) {
    var v = canFire(p);
    if (v) {
        return {
            gun: {
                pos: p.pos,
                angle: p.angle,
                shotCoolDown: Constants.pistolShotCooldown,
                shotCount: p.shotCount - 1 | 0,
                appear: p.appear,
                sprite: p.sprite
            },
            bullets: [ Data_Bullet.newBullet(Data_Bullet.BulletForward.value)(p.pos) ]
        };
    };
    if (!v) {
        return {
            gun: p,
            bullets: [  ]
        };
    };
    throw new Error("Failed pattern match at Data.Gun.Pistol (line 22, column 16 - line 33, column 6): " + [ v.constructor.name ]);
};
module.exports = {
    Left: Left,
    Right: Right,
    firePistol: firePistol,
    reloadPistol: reloadPistol,
    canFire: canFire
};
