define [
  "ldfw",
  "actors/mobs/mob-actor"
], (LDFW, MobActor) ->
  class LazerActor extends MobActor
    constructor: (@game, @gameState, @mob) ->
      super

      {@player, @level} = @gameState
      {@spritesAtlas} = @game

      @animationSprite = @spritesAtlas.createAnimSprite "mobs/lazer.png", 2, 0.1

    update: (delta) ->
      super
      @animationSprite.update delta

    draw: (context) ->
      super

      x = @mob.position.x
      y = @game.getHeight() + @level.scrollPosition - @animationSprite.getHeight() - @mob.position.y

      @animationSprite.draw context, x, y
