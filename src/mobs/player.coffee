define ["ldfw"], (LDFW) ->
  class Player
    jumpForce: 1200
    onGround: true
    lookDirection: 0
    constructor: (@game, @gameState) ->
      {@level} = @gameState
      @depth = @level.initialDepth
      @keyboard = new LDFW.Keyboard

      @position = new LDFW.Vector2 @game.getWidth() / 2, @level.floorHeight
      @velocity = new LDFW.Vector2(0, 0)
      @speed = new LDFW.Vector2(5, 0)
      @hitBox = new LDFW.Rectangle(0, 0, 20, 30)

      @items = []

    update: (delta) ->
      @_handleKeyboardInput()
      @_calculateDepth()

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

    _calculateDepth: ->
      pixelsTravelled = @position.y - @level.floorHeight
      @depth = Math.round(@level.initialDepth + pixelsTravelled * @level.depthPerPixel)

    _findMinimumYForPosition: (position) ->
      minY = @level.floorHeight
      for platform in @level.platforms
        unless @position.x + @hitBox.width < platform.x or
          @position.x > platform.x + platform.width or
          @position.y < platform.y
            minY = Math.max(minY, platform.y)

      return minY

    _handleKeyboardInput: ->
      moveLeft = @keyboard.pressed @keyboard.Keys.LEFT
      moveRight = @keyboard.pressed @keyboard.Keys.RIGHT
      lookUp = @keyboard.pressed @keyboard.Keys.UP
      lookDown = @keyboard.pressed @keyboard.Keys.DOWN
      jump = @keyboard.pressed @keyboard.Keys.C

      if lookUp
        @lookDirection = -1
      else if lookDown
        @lookDirection = 1
      else
        @lookDirection = 0

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

    pickItem: (item) ->
      hasItem = false
      for otherItem in @items
        if otherItem instanceof item.constructor
          hasItem = true

      console.log "got this already" if hasItem

      @items.push item

    getRect: ->
      {level} = @gameState
      x = @position.x
      y = @game.getHeight() + level.scrollPosition - @hitBox.height - @position.y
      w = @hitBox.width
      h = @hitBox.height
      return new LDFW.Rectangle(x, y, w, h)

    intersectsWith: (rect) ->
      playerRect = @getRect()

      if playerRect.position.x + playerRect.width < rect.position.x or
        playerRect.x > rect.x + rect.width or
        playerRect.position.y + playerRect.height < rect.position.y or
        playerRect.position.y > rect.position.y + rect.height
          return false

      return true
