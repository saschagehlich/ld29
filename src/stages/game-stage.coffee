define [
  "ldfw",
  "actors/level-actor"
], (LDFW, LevelActor) ->
  class GameStage extends LDFW.Stage
    constructor: (@game, @gameState) ->
      super

      @levelActor = new LevelActor @game, @gameState
      @addActor @levelActor
