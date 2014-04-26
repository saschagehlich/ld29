define ["ldfw", "actors/weapon-actor"], (LDFW, WeaponActor) ->
  class Weapon
    picked: false
    player: null
    cooldown: 0.5
    lastUse: 0
    sinceLastUse: 0
    projectileClass: null
    constructor: (@game, @gameState, x, y) ->
      @position = new LDFW.Vector2(x, y)
      @actor = new WeaponActor @game, @gameState, this, @spriteName
      return

    update: (delta) ->
      @actor.update delta
      @sinceLastUse += delta

    getRect: ->
      {level} = @gameState
      x = @position.x
      y = @position.y
      w = @actor.getWidth()
      h = @actor.getHeight()

      return new LDFW.Rectangle(x, y, w, h)

    setPlayer: (@player) ->

    use: (delta) ->
      return if @sinceLastUse < @cooldown

      projectile = new @projectileClass(@game, @gameState,
        this, @player
      )
      @gameState.level.addProjectile projectile

      @sinceLastUse = 0
