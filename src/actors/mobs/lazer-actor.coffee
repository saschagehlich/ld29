define [
  "ldfw",
  "actors/mobs/mob-actor"
], (LDFW, MobActor) ->
  class LazerActor extends MobActor
    constructor: (@game, @gameState, @mob) ->
      super

      {@player, @level} = @gameState
      {@spritesAtlas} = @game

      @animationSprite = @spritesAtlas.createAnimSprite "mobs/lazer.png", 2, 0.05

    update: (delta) ->
      super
      @animationSprite.update delta

    draw: (context) ->
      x = @mob.position.x
      y = @game.getHeight() + @level.scrollPosition - @animationSprite.getHeight() - @mob.position.y

      context.save()
      context.globalAlpha = @mobOpacity
      @animationSprite.draw context, x, y
      context.restore()

      super


