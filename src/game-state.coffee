define ["level", "mobs/player"], (Level, Player) ->
  class GameState
    constructor: (@game) ->
      @level = new Level @game, this
      @player = new Player @game, this

    update: (delta) ->
      @level.update delta
      @player.update delta
