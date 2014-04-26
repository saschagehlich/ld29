define ["ldfw", "entities/platform"], (LDFW, Platform) ->
  class Level
    floorHeight: 40
    scrollPosition: 0
    constructor: (@game, @gameState) ->
      @gravity = new LDFW.Vector2(0, -4000)
      @boundaries =
        min: new LDFW.Vector2(100, 0)
        max: new LDFW.Vector2(@game.getWidth() - 50, 0)

      @platforms = [
        new Platform(420, 160, 100),
        new Platform(250, 250, 100),
        new Platform(420, 320, 100),
      ]

    update: (delta) ->
      {player} = @gameState

      if player.position.y > @game.getHeight() / 2
        scrollPosition = player.position.y - @game.getHeight() / 2
      else
        scrollPosition = 0

      self = this
      TWEEN.remove @scrollTween
      @scrollTween = new TWEEN.Tween(this)
        .to({ scrollPosition }, 200)
        .easing(TWEEN.Easing.Quartic.Out)
        .start()
