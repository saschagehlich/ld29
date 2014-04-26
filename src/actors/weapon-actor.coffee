define [
  "ldfw"
], (LDFW) ->
  class WeaponActor extends LDFW.Actor
    hoverOffset: 0
    sumDelta: 0
    constructor: (@game, @gameState, @weapon, @spriteName) ->
      super

      {@spritesAtlas} = @game

      @weaponSprite = @spritesAtlas.createSprite "weapons/#{spriteName}.png"

    draw: (context, x, y, mirroredX=false) ->
      weaponSprite = @weaponSprite

      unless x? and y?
        {x, y} = @weapon.position
        y += @hoverOffset

        {level} = @gameState
        y = @game.getHeight() + level.scrollPosition - y

      weaponSprite.draw context, x, y, mirroredX

    update: (delta) ->
      @hoverOffset = Math.sin(@sumDelta * 2) * 3
      @sumDelta += delta

    getWidth: -> @weaponSprite.getWidth()
    getHeight: -> @weaponSprite.getHeight()
