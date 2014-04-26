define [
  "ldfw"
], (LDFW) ->
  class PlayerActor extends LDFW.Actor
    height: 30
    constructor: (@game, @gameState) ->
      super

      {@player, @level} = @gameState
      {@spritesAtlas} = @game

      @headSprite = @spritesAtlas.createSprite "player/head.png"

      @handsSprites =
        idle: @spritesAtlas.createSprite "player/hands-idle.png"

      @bodySprite = @spritesAtlas.createSprite "player/body.png"

      @feetSprites =
        idle: @spritesAtlas.createSprite "player/feet-idle.png"

    update: ->
      super

      if item = @player.activeItem
        item.position.set @player.position
        item.position.y += 12

    draw: (context) ->
      sprite = @idleSprite

      mirroredX = false
      if @player.direction is -1
        mirroredX = true

      x = @player.position.x
      y = @game.getHeight() + @level.scrollPosition - @height - @player.position.y

      bodySprite = @bodySprite
      headSprite = @headSprite
      handsSprite = @handsSprites.idle
      feetSprite = @feetSprites.idle

      bodySprite.draw(context, x, y + 16, mirroredX)
      headSprite.draw(context, x, y, mirroredX)
      feetSprite.draw(context, x, y + 26, mirroredX)

      # Render the item the player is holding
      if item = @player.activeItem
        {actor} = item
        itemX = x
        itemY = y + 18
        if mirroredX
          itemX -= 10
        actor.draw context,
          itemX,
          itemY,
          mirroredX

      handsSprite.draw(context, x, y + 22, mirroredX)
