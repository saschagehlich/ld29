define [
  "ldfw",
  "./mob"
], (LDFW, Mob) ->
  class FlyingMob extends Mob
    ignoreGravity: true
    constructor: ->
      super

      @speed = new LDFW.Vector2(100, 100)
      @target = @gameState.player

    update: (delta) ->
      # Let flying mobs fly towards the player per default
      {position} = @target
      direction = Math.atan2(position.y - @position.y, position.x - @position.x)

      directionX = Math.cos(direction) * @speed.x
      directionY = Math.sin(direction) * @speed.y
      @velocity = new LDFW.Vector2(directionX, directionY)

      super
