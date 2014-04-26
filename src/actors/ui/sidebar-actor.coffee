define [
  "ldfw"
], (LDFW) ->
  class SidebarActor extends LDFW.Actor
    constructor: (@game, @gameState) ->
      super

      {@player} = @gameState
      {@fontsAtlas} = @game

      @font = new LDFW.BitmapFont(
        @game.preloader.get("assets/fonts/pixel-8-white.fnt"),
        @fontsAtlas.findRegion("pixel-8-white.png")
      )

    draw: (context) ->
      {depth} = @player

      text = "#{depth}m"
      bounds = @font.getBounds text
      @font.drawText context, text, 50 - bounds.width / 2, 10
