define [
  "./weapon",
  "./projectiles/bazooka-projectile"
], (Weapon, BazookaProjectile) ->
  class Pistol extends Weapon
    spriteName: "bazooka"
    projectileClass: BazookaProjectile
    cooldown: 1
