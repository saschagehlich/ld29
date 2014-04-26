define [
  "ldfw"
], (LDFW, LevelActor) ->
  class LevelActor extends LDFW.Actor
    constructor: (@game, @gameState) ->
      super

      {@spritesAtlas} = @game

      @wallSprite = @spritesAtlas.createSprite "world/wall.png"

    draw: (context) ->
      yPosition = @gameState.getScrollPosition() % @wallSprite.getHeight()

      if yPosition < @game.getHeight()
        @wallSprite.draw context, 0, yPosition
        @wallSprite.draw context,
          @game.getWidth() - @wallSprite.getWidth() / 2,
          yPosition,
          true, true

      if yPosition > 0
        @wallSprite.draw context, 0, yPosition - @wallSprite.getHeight()
        @wallSprite.draw context,
          @game.getWidth() - @wallSprite.getWidth() / 2,
          yPosition - @wallSprite.getHeight(),
          true, true
