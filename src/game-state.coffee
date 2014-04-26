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
      @level.addMob new Lazer(@game, this)

    update: (delta) ->
      @level.update delta
