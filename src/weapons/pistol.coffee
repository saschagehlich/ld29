define [
  "./weapon",
  "./projectiles/pistol-projectile"
], (Weapon, PistolProjectile) ->
  class Pistol extends Weapon
    spriteName: "pistol"
    projectileClass: PistolProjectile
    cooldown: 0.4
