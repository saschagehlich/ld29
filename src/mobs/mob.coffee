define ["ldfw", "lib/mouse"], (LDFW, Mouse) ->
  class Mob
    jumpForce: 1200
    onGround: true
    ignoreGravity: false
    maxHealth: 100
    destroyed: false
    exploding: false
    constructor: (@game, @gameState) ->
      {@level} = @gameState

      @health = @maxHealth

      @position = new LDFW.Vector2()
      @velocity = new LDFW.Vector2()
      @speed = new LDFW.Vector2()
      @hitBox = new LDFW.Rectangle(0, 0, 0, 0)

    update: (delta) ->
      minY = @_findMinimumYForPosition @position

      unless @exploding
        gravityStep = @level.gravity.clone()
        gravityStep.multiply delta

        unless @ignoreGravity
          @velocity.add gravityStep

        velocityStep = @velocity.clone()
        velocityStep.multiply delta

        @position.add velocityStep

        @position.x = Math.max(@level.boundaries.min.x, @position.x)
        @position.x = Math.min(@level.boundaries.max.x, @position.x)

        @position.y = Math.max(minY, @position.y)
        @onGround = @position.y is minY
        if @onGround
          @velocity.y = 0

      if @exploding
        debug @explodingTimeLeft
        @explodingTimeLeft -= delta
        if @explodingTimeLeft < 0
          @destroyed = true

    _findMinimumYForPosition: (position) ->
      minY = @level.floorHeight
      for platform in @level.platforms
        unless @position.x + @hitBox.width < platform.x or
          @position.x > platform.x + platform.width or
          @position.y < platform.y
            minY = Math.max(minY, platform.y)

      return minY

    getRect: ->
      {level} = @gameState
      x = @position.x
      y = @position.y
      w = @hitBox.width
      h = @hitBox.height
      return new LDFW.Rectangle(x, y, w, h)

    intersectsWith: (rect) ->
      mobRect = @getRect()

      if mobRect.position.x + mobRect.width < rect.position.x or
        mobRect.position.x > rect.position.x + rect.width or
        mobRect.position.y + mobRect.height < rect.position.y or
        mobRect.position.y > rect.position.y + rect.height
          return false

      return true

    hurt: (damage) ->
      @health -= damage
      @health = Math.max(0, @health)

      if @health is 0 and not (@exploding or @destroyed)
        @destroy()

    destroy: ->
      @exploding = true
      @explodingTimeLeft = 0.7
