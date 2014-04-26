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

      @platformEdgeSprite = @spritesAtlas.createSprite "world/platform-edge.png"

    draw: (context) ->
      super

      @_drawPlatforms context
      @_drawItems context
      @_drawProjectiles context

    _drawPlatforms: (context) ->
      {platforms} = @level
      edgeWidth = @platformEdgeSprite.getWidth()

      for platform in platforms
        {x, y, width, height} = platform

        y = @level.scrollPosition + @game.getHeight() - y
        @platformEdgeSprite.draw context, x, y

        context.save()
        context.fillStyle = "#3e4151"
        context.fillRect x + edgeWidth, y, platform.width - edgeWidth * 2, platform.height
        context.restore()

        @platformEdgeSprite.draw context, x + width - edgeWidth, y, true

    _drawItems: (context) ->
      {items} = @level
      for item in items
        {actor} = item
        actor.draw context

    _drawProjectiles: (context) ->
      {projectiles} = @level
      for projectile in projectiles
        {actor} = projectile
        actor.draw context

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
