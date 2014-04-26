define ["ldfw", "actors/projectiles/projectile-actor"], (LDFW, ProjectileActor) ->
  class Projectile
    actorClass: ProjectileActor
    spriteName: null
    constructor: (@game, @gameState, @weapon, @mob) ->
      @actor = new @actorClass(@game, @gameState, this, @spriteName)
      @position = @mob.position.clone()
      @direction = new LDFW.Vector2(@mob.direction, @mob.lookDirection)

    update: (delta) ->
      @position.x += @direction.x * @speed * delta
      @position.y += @direction.y * @speed * delta
