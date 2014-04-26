define ["ldfw", "actors/weapon-actor"], (LDFW, WeaponActor) ->
  class Weapon
    picked: false
    player: null
    constructor: (@game, @gameState, x, y) ->
      @position = new LDFW.Vector2(x, y)
      @actor = new WeaponActor @game, @gameState, this, @spriteName
      return

    update: (delta) ->
      @actor.update delta
