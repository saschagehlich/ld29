define ["ldfw", "./mob", "lib/mouse"], (LDFW, Mob, Mouse) ->
  class Player extends Mob
    jumpForce: 1200
    onGround: true
    constructor: ->
      super
      {@level} = @gameState
      @depth = @level.initialDepth
      @keyboard = new LDFW.Keyboard
      @mouse = new Mouse(@game.wrapper)

      @position = new LDFW.Vector2 @game.getWidth() / 2, @level.floorHeight

      @speed = new LDFW.Vector2(400, 0)
      @hitBox = new LDFW.Rectangle(0, 0, 20, 30)

      @lookDirection = new LDFW.Vector2(1, 0)
      @moveDirection = 1

      @items = []

    update: (delta) ->
      super

      @_handleUserInput()
      @_calculateDepth()

      # Item usage / weapon shooting
      @activeItem?.update delta
      if @usingItem and @activeItem?
        @activeItem.use delta

    _calculateDepth: ->
      pixelsTravelled = @position.y - @level.floorHeight
      @depth = Math.round(@level.initialDepth + pixelsTravelled * @level.depthPerPixel)

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
