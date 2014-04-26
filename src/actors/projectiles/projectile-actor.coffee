define ["ldfw"], (LDFW) ->
  class ProjectileActor extends LDFW.Actor
    constructor: (@game, @gameState, @projectile, @spriteName) ->
      super

      {@spritesAtlas} = @game

      @projectileSprite = @spritesAtlas.createSprite(
        "weapons/#{spriteName}-projectile.png"
      )
      @projectileExplosionSprite = @spritesAtlas.createSprite(
        "weapons/projectile-explosion.png"
      )

    draw: (context) ->
      projectileSprite = @projectileSprite

      if @projectile.exploding
        projectileSprite = @projectileExplosionSprite

      {x, y} = @projectile.position
      {level} = @gameState
      y = @game.getHeight() + level.scrollPosition - y

      projectileSprite.draw context, x, y

