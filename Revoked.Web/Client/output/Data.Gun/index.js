// Generated by purs version 0.12.5
"use strict";
var Class_Object = require("../Class.Object/index.js");
var Data_Gun_Pistol = require("../Data.Gun.Pistol/index.js");
var Emo8_Action_Draw = require("../Emo8.Action.Draw/index.js");
var Emo8_Data_Sprite = require("../Emo8.Data.Sprite/index.js");
var PistolGun = (function () {
    function PistolGun(value0) {
        this.value0 = value0;
    };
    PistolGun.create = function (value0) {
        return new PistolGun(value0);
    };
    return PistolGun;
})();
var updateGun = function (v) {
    return PistolGun.create({
        pos: v.value0.pos,
        angle: v.value0.angle,
        shotCoolDown: v.value0.shotCoolDown,
        shotCount: v.value0.shotCount,
        appear: v.value0.appear,
        sprite: Emo8_Data_Sprite.incrementFrame(v.value0.sprite)
    });
};
var toGunAndBullets = function (mapper) {
    return function (r) {
        return {
            gun: mapper(r.gun),
            bullets: r.bullets
        };
    };
};
var reloadGun = function (v) {
    return PistolGun.create(Data_Gun_Pistol.reloadPistol(v.value0));
};
var objectGun = new Class_Object["Object"](function (v) {
    return v.value0.pos;
}, function (offset) {
    return function (v) {
        return PistolGun.create({
            pos: {
                x: v.value0.pos.x + offset | 0,
                y: v.value0.pos.y
            },
            angle: v.value0.angle,
            shotCoolDown: v.value0.shotCoolDown,
            shotCount: v.value0.shotCount,
            appear: v.value0.appear,
            sprite: v.value0.sprite
        });
    };
}, function (v) {
    return v.value0.sprite.size;
});
var objectDrawGun = new Class_Object.ObjectDraw(function () {
    return objectGun;
}, function (v) {
    return Emo8_Action_Draw.drawSprite(v.value0.sprite)((Class_Object.position(objectGun)(v)).x)((Class_Object.position(objectGun)(v)).y);
});
var fireGun = function (v) {
    return toGunAndBullets(PistolGun.create)(Data_Gun_Pistol.firePistol(v.value0));
};
module.exports = {
    PistolGun: PistolGun,
    fireGun: fireGun,
    reloadGun: reloadGun,
    updateGun: updateGun,
    toGunAndBullets: toGunAndBullets,
    objectGun: objectGun,
    objectDrawGun: objectDrawGun
};