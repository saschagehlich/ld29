define ["ldfw"], (LDFW) ->
  class ProjectileActor extends LDFW.Actor
    constructor: (@game, @gameState, @projectile, @spriteName) ->
      super

      {@spritesAtlas} = @game

      @projectileSprite = @spritesAtlas.createSprite(
        "weapons/#{spriteName}-projectile.png"
      )
      @projectileSpriteRotated = @spritesAtlas.createSprite(
        "weapons/#{spriteName}-projectile-rotated.png"
      )

    draw: (context) ->
      projectileSprite = @projectileSprite
      mirroredX = false
      if @projectile.direction.y isnt 0
        projectileSprite = @projectileSpriteRotated
      if @projectile.direction.x isnt @projectile.direction.y
        mirroredX = true

      {x, y} = @projectile.position
      {level} = @gameState
      y = @game.getHeight() + level.scrollPosition - y

      projectileSprite.draw context, x, y, mirroredX

