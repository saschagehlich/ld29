define ["ldfw"], (LDFW) ->
  class Level
    floorHeight: 40
    scrollPosition: 0
    constructor: (@game, @gameState) ->
      @gravity = new LDFW.Vector2(0, -2000)
      @boundaries =
        min: new LDFW.Vector2(100, 0)
        max: new LDFW.Vector2(@game.getWidth() - 50, 0)

    update: (delta) ->
      return
