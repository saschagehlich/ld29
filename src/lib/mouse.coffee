define ["ldfw", "jquery"], (LDFW, $) ->
  class Mouse
    pressed: false
    constructor: (@wrapper) ->
      @position = new LDFW.Vector2()

      $(@wrapper).mousemove (e) =>
        e.preventDefault()
        offset = @wrapper.offset()
        x = e.pageX - offset.left
        y = e.pageY - offset.top
        @position.set x, y

      $(@wrapper).mousedown (e) =>
        e.preventDefault()
        @pressed = true

      $(@wrapper).mouseup (e) =>
        e.preventDefault()
        @pressed = false

    getDirectionFrom: (position) ->
      direction = Math.atan2(position.y - @position.y, position.x - @position.x)
      return new LDFW.Vector2(Math.cos(direction) * -1, Math.sin(direction))
