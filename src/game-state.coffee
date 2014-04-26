define [
  "level",
  "mobs/player",
  "mobs/lazer"
], (Level, Player, Lazer) ->
  class GameState
    constructor: (@game) ->
      @level = new Level @game, this
      @player = new Player @game, this

      @level.addMob @player

      for i in [0...5]
        lazer = new Lazer(@game, this)
        lazer.position.set(
          @level.boundaries.min.x + Math.random() * 200,
          @level.floorHeight + Math.random() * 500
        )
        @level.addMob lazer

    update: (delta) ->
      @level.update delta
