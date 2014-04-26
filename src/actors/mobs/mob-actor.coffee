define [
  "ldfw"
], (LDFW) ->
  class MobActor extends LDFW.Actor
    healthBarWidth: 50
    healthBarHeight: 5
    healthBarPadding: 1
    explosionColors: [
      "#bc3d20", "#db5c0f", "#bd3819", "#dc7c1e"
    ]
    animatingDeath: false
    mobOpacity: 1
    constructor: (@game, @gameState, @mob) ->
      super

      @explosionCircles = []

    update: (delta) ->
      if @mob.exploding and not @animatingDeath
        @deathTween = new TWEEN.Tween(this)
          .delay(100)
          .to(mobOpacity: 0, 200)
          .easing(TWEEN.Easing.Linear.None)
          .start()

        for i in [0...30]
          colorIndex = Math.round(Math.random() * @explosionColors.length)
          color = @explosionColors[colorIndex]

          explosionCircle = {
            size: 0,
            toSize: 5 + Math.random() * 25,
            color: color,
            x: Math.random() * @mob.hitBox.width,
            y: Math.random() * @mob.hitBox.height
          }
          @explosionCircles.push explosionCircle

          do (explosionCircle) =>
            scaleUp = new TWEEN.Tween(explosionCircle)
              .delay(i * 20)
              .to(size: explosionCircle.toSize, 100)
              .easing(TWEEN.Easing.Exponential.In)

            scaleDown = new TWEEN.Tween(explosionCircle)
              .to(size: 0, 300)
              .easing(TWEEN.Easing.Exponential.Out)

            scaleUp.chain scaleDown
            scaleDown.onComplete =>
              @explosionCircles.splice @explosionCircles.indexOf(explosionCircle, 1)
            scaleUp.start()

        @animatingDeath = true

    draw: (context) ->
      super
      if @mob.health < @mob.maxHealth and @mob.health > 0
        @_drawHealthBar context

      @_drawExplosion context

    _drawExplosion: (context) ->
      context.save()
      for circle in @explosionCircles
        debug circle.size
        context.fillStyle = circle.color
        context.beginPath()

        {x, y} = circle
        x += @mob.position.x
        y += @mob.position.y

        y = @game.getHeight() + @level.scrollPosition - y

        context.arc x, y, circle.size, 0, 2 * Math.PI, false
        context.fill()
        context.closePath()
      context.restore()

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

