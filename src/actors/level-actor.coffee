define [
  "ldfw"
], (LDFW) ->
  class LevelActor extends LDFW.Actor
    constructor: (@game, @gameState) ->
      super

      {@level} = @gameState
      {@spritesAtlas} = @game

      @wallSprite = @spritesAtlas.createSprite "world/wall.png"
      @floorSprite = @spritesAtlas.createSprite "world/floor.png"

    drawFloor: (context) ->
      yPosition = @level.scrollPosition + @game.getHeight() - @floorSprite.getHeight()
      if yPosition < @game.getHeight()
        @floorSprite.draw context, 0, yPosition

    drawWalls: (context) ->
      yPosition = @level.scrollPosition % @wallSprite.getHeight()

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
