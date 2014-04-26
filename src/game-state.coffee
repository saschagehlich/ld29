define [], ->
  class GameState
    scrollPosition: 0

    constructor: (@game) ->
      return

    update: (delta) ->
      @scrollPosition += delta * 30

    getScrollPosition: -> @scrollPosition
