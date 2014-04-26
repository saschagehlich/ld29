define ["ldfw", "actors/projectiles/projectile-actor"], (LDFW, ProjectileActor) ->
  class Projectile
    actorClass: ProjectileActor
    spriteName: null
    destroyed: false
    exploding: false
    constructor: (@game, @gameState, @weapon, @mob) ->
      @actor = new @actorClass(@game, @gameState, this, @spriteName)
      @position = @mob.position.clone()
      @direction = new LDFW.Vector2(@mob.direction, @mob.lookDirection)

    update: (delta) ->
      unless @exploding
        @position.x += @direction.x * @speed * delta
        @position.y += @direction.y * @speed * delta
      else
        if @explodingDuration < 0
          @destroyed = true
        else
          @explodingDuration -= delta

    explode: ->
      @exploding = true
      @explodingDuration = 0.1
