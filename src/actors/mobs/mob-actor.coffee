define [
  "ldfw"
], (LDFW) ->
  class MobActor extends LDFW.Actor
    healthBarWidth: 50
    healthBarHeight: 5
    healthBarPadding: 1
    constructor: (@game, @gameState, @mob) ->
      super

    draw: (context) ->
      super
      if @mob.health < @mob.maxHealth
        @_drawHealthBar context

    _drawHealthBar: (context) ->
      x = @mob.position.x
      y = @game.getHeight() + @level.scrollPosition - @animationSprite.getHeight() - @mob.position.y

      context.save()

      context.fillStyle = "#383c4a"
      context.strokeStyle = "#383c4a"
      context.strokeWidth = 2

      context.beginPath()
      context.rect(
        x + @mob.hitBox.width / 2  - @healthBarWidth / 2,
        y - 20,
        @healthBarWidth,
        @healthBarHeight
      )
      context.closePath()
      context.stroke()

      healthBarWidth = @healthBarWidth - @healthBarPadding * 2
      context.fillRect(
        x + @mob.hitBox.width / 2 - @healthBarWidth / 2 + @healthBarPadding,
        y - 20 + @healthBarPadding,
        healthBarWidth / @mob.maxHealth * @mob.health,
        @healthBarHeight - @healthBarPadding * 2
      )

      context.restore()
