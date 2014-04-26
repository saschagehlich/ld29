define ["ldfw"], (LDFW) ->
  class Player
    jumpForce: 1200
    onGround: true
    constructor: (@game, @gameState) ->
      {@level} = @gameState
      @keyboard = new LDFW.Keyboard

      @position = new LDFW.Vector2 @game.getWidth() / 2, @level.floorHeight
      @velocity = new LDFW.Vector2(0, 0)
      @speed = new LDFW.Vector2(5, 0)
      @hitBox = new LDFW.Vector2(20, 30)

    update: (delta) ->
      @_handleKeyboardInput()

      minY = @_findMinimumYForPosition @position

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

      @position.y = Math.max(minY, @position.y)
      @onGround = @position.y is minY
      if @onGround
        @velocity.y = 0

    _findMinimumYForPosition: (position) ->
      minY = @level.floorHeight
      for platform in @level.platforms
        unless @position.x + @hitBox.x < platform.x or
          @position.x > platform.x + platform.width or
          @position.y < platform.y
            minY = Math.max(minY, platform.y)

      return minY

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
