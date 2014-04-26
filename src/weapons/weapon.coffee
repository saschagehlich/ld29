define ["ldfw", "actors/weapon-actor"], (LDFW, WeaponActor) ->
  class Weapon
    picked: false
    player: null
    cooldown: 0.5
    lastUse: 0
    constructor: (@game, @gameState, x, y) ->
      @position = new LDFW.Vector2(x, y)
      @actor = new WeaponActor @game, @gameState, this, @spriteName
      return

    update: (delta) ->
      @actor.update delta

    getRect: ->
      {level} = @gameState
      x = @position.x
      y = @game.getHeight() + level.scrollPosition - @position.y
      w = @actor.getWidth()
      h = @actor.getHeight()

      return new LDFW.Rectangle(x, y, w, h)

    setPlayer: (@player) ->

    use: (delta) ->
      @sinceLastUse += delta
      return if @sinceLastUse < @cooldown

      console.log "PEW"

      @sinceLastUse = 0
