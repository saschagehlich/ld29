define ["ldfw"], (LDFW) ->
  class Player
    jumpForce: 800
    onGround: true
    constructor: (@game, @gameState) ->
      {@level} = @gameState
      @keyboard = new LDFW.Keyboard

      @position = new LDFW.Vector2 @game.getWidth() / 2, @level.floorHeight
      @velocity = new LDFW.Vector2(0, 0)
      @speed = new LDFW.Vector2(5, 0)

    update: (delta) ->
      @_handleKeyboardInput()

      # Handle velocity / movement
      @position.x += @velocity.x
      @position.x = Math.max(@level.boundaries.min.x, @position.x)
      @position.x = Math.min(@level.boundaries.max.x, @position.x)

      gravityStep = @level.gravity.clone()
      gravityStep.multiply delta

      @velocity.add gravityStep

      velocityStep = @velocity.clone()
      velocityStep.multiply delta

      @position.add(velocityStep)

      @position.y = Math.max(@level.floorHeight, @position.y)
      @onGround = @position.y is @level.floorHeight

    _handleKeyboardInput: ->
      moveLeft = @keyboard.pressed @keyboard.Keys.LEFT
      moveRight = @keyboard.pressed @keyboard.Keys.RIGHT
      jump = @keyboard.pressed @keyboard.Keys.UP

      if moveLeft
        @velocity.x = -@speed.x
        @direction = -1
      else if moveRight
        @velocity.x = @speed.x
        @direction = 1
      else
        @velocity.x = 0

      if jump and @onGround
        @velocity.y = @jumpForce
