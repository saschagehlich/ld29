define ["ldfw", "actors/projectiles/projectile-actor"], (LDFW, ProjectileActor) ->
  class Projectile
    actorClass: ProjectileActor
    spriteName: null
    destroyed: false
    exploding: false
    constructor: (@game, @gameState, @weapon, @mob) ->
      @position = @mob.position.clone()
      @direction = @mob.lookDirection.clone()

      @actor = new @actorClass(@game, @gameState, this, @spriteName)

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
