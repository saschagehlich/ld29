define [
  "ldfw"
], (LDFW) ->
  class PlayerActor extends LDFW.Actor
    constructor: (@game, @gameState) ->
      super

      {@player, @level} = @gameState
      {@spritesAtlas} = @game

      @idleSprite = @spritesAtlas.createSprite "player/idle.png"

    draw: (context) ->
      sprite = @idleSprite

      mirroredX = false
      if @player.direction is -1
        mirroredX = true

      x = @player.position.x
      y = @game.getHeight() + @level.scrollPosition - sprite.getHeight() - @player.position.y
      @idleSprite.draw context, x, y, mirroredX
