define [
  "ldfw",
  "actors/ui/sidebar-actor"
], (LDFW, SidebarActor) ->
  class GameUIStage extends LDFW.Stage
    constructor: (@game, @gameState) ->
      super

      @sidebarActor = new SidebarActor @game, @gameState
      @addActor @sidebarActor
