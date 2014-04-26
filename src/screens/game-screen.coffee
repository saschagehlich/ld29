define [
  "ldfw",
  "stages/game-stage",
  "stages/game-ui-stage",
  "game-state"
], (LDFW, GameStage, GameUIStage, GameState) ->
  class GameScreen extends LDFW.Screen
    constructor: ->
      super

      @gameState = new GameState @game
      @gameStage = new GameStage @game, @gameState
      @gameUIStage = new GameUIStage @game, @gameState

    ###
     * Update positions etc.
     * @param  {Number} delta Time passed since the last tick
    ###
    update: (delta) ->
      @gameState.update delta
      @gameStage.update delta
      @gameUIStage.update delta
      return

    ###
     * Draw the stage
     * @param  {Canvas2DContext} context
    ###
    draw: (context) ->
      context.fillStyle = "#51566a"
      context.fillRect 0, 0, context.canvas.width, context.canvas.height

      @gameStage.draw context
      @gameUIStage.draw context
      return
