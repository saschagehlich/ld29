define [
  "ldfw",
  "actors/level-actor",
  "actors/player-actor"
], (LDFW, LevelActor, PlayerActor) ->
  class GameStage extends LDFW.Stage
    constructor: (@game, @gameState) ->
      super

      @levelActor = new LevelActor @game, @gameState
      @addActor @levelActor

      @playerActor = new PlayerActor @game, @gameState
      @addActor @playerActor

    draw: (context) ->
      @levelActor.drawFloor context
      super
      @levelActor.drawWalls context
