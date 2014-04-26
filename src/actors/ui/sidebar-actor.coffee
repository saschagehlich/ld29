define [
  "ldfw"
], (LDFW) ->
  class SidebarActor extends LDFW.Actor
    width: 100
    lineHeight: 290
    lineTop: 45
    lineWidth: 2
    constructor: (@game, @gameState) ->
      super

      {@player, @level} = @gameState
      {@fontsAtlas, @spritesAtlas} = @game

      @font = new LDFW.BitmapFont(
        @game.preloader.get("assets/fonts/pixel-8-white.fnt"),
        @fontsAtlas.findRegion("pixel-8-white.png")
      )

      @sunSprite = @spritesAtlas.createSprite "ui/sidebar/sun.png"
      @playerSprite = @spritesAtlas.createSprite "ui/sidebar/player.png"

    draw: (context) ->
      @_drawDepth context
      @_drawTimeline context

    _drawDepth: (context) ->
      {depth} = @player

      text = "#{depth}m"
      bounds = @font.getBounds text
      @font.drawText context, text, @width / 2 - bounds.width / 2, 10

    _drawTimeline: (context) ->
      # Basic line
      context.save()
      context.fillStyle = "rgba(255, 255, 255, 0.1)"
      context.fillRect @width / 2 - @lineWidth / 2, @lineTop, @lineWidth, @lineHeight
      context.restore()

      # Sun
      @sunSprite.draw context,
        @width / 2 - @sunSprite.getWidth() / 2,
        @lineTop - @sunSprite.getHeight() / 2

      # Player
      lowestLinePoint = @lineTop + @lineHeight
      playerY = lowestLinePoint - (1 - @player.depth / @level.initialDepth) * @lineHeight
      @playerSprite.draw context,
        @width / 2 - @playerSprite.getWidth() / 2,
        playerY - @playerSprite.getHeight() / 2
