define [
  "./weapon",
  "./projectiles/machinegun-projectile"
], (Weapon, MachineGunProjectile) ->
  class MachineGun extends Weapon
    spriteName: "machinegun"
    projectileClass: MachineGunProjectile
    cooldown: 0.05
    constructor: ->
      super
