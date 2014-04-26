define ["ldfw", "lib/mouse"], (LDFW, Mouse) ->
  class Player
    jumpForce: 1200
    onGround: true
    constructor: (@game, @gameState) ->
      {@level} = @gameState
      @depth = @level.initialDepth
      @keyboard = new LDFW.Keyboard
      @mouse = new Mouse(@game.wrapper)

      @position = new LDFW.Vector2 @game.getWidth() / 2, @level.floorHeight
      @velocity = new LDFW.Vector2(0, 0)
      @speed = new LDFW.Vector2(5, 0)
      @hitBox = new LDFW.Rectangle(0, 0, 20, 30)

      @lookDirection = new LDFW.Vector2(1, 0)
      @moveDirection = 1

      @items = []

    update: (delta) ->
      @_handleUserInput()
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

      # Item usage / weapon shooting
      if @usingItem and @activeItem?
        @activeItem.use delta

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

    _handleUserInput: ->
      moveLeft = @keyboard.pressed @keyboard.Keys.A
      moveRight = @keyboard.pressed @keyboard.Keys.D

      shoot = @mouse.pressed

      jump = @keyboard.pressed(@keyboard.Keys.SPACE) or
        @keyboard.pressed(@keyboard.Keys.W)

      if moveLeft
        @velocity.x = -@speed.x
      else if moveRight
        @velocity.x = @speed.x
      else
        @velocity.x = 0

      if shoot
        @usingItem = true
      else
        @usingItem = false

      screenPosition = @position.clone()
      screenPosition.y = @game.getHeight() + @level.scrollPosition - @hitBox.height - @position.y
      @lookDirection = @mouse.getDirectionFrom screenPosition

      # JUMP JUMP!
      if jump and @onGround
        @velocity.y = @jumpForce

    pickItem: (item) ->
      hasItem = false
      for otherItem in @items
        if otherItem instanceof item.constructor
          hasItem = true

      console.log "got this already" if hasItem

      item.setPlayer this
      @items.push item
      @activeItem ?= item

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
